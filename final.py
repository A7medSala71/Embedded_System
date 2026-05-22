#!/usr/bin/env python3
"""final.py
==========

Raspberry Pi UART bridge — reads telemetry from the PIC16F877A over
serial and pushes structured data to Firebase Realtime Database.

PIC sends one line every ~100 ms in the format:
    F:045 R:180 L:200 D:0 B:1

Where:
    F = Front  ultrasonic distance (cm)  – 999 means no echo
    R = Right  ultrasonic distance (cm)
    L = Left   ultrasonic distance (cm)
    D = Door   sensor  (0 = CLOSED/safe, 1 = OPEN/danger)
    B = Belt   sensor  (0 = UNBUCKLED,   1 = FASTENED/safe)

Firebase path written: /car_telemetry
Firebase path read:    /eye_monitor  (set by eye_to_pic.py / Android app)

The script also reads the current eye-monitor state from Firebase and
echoes 'E' (eyes open) or 'C' (eyes closed) to the PIC over UART,
acting as a combined telemetry + eye-relay bridge.

Usage
-----
    pip install requests pyserial firebase-admin
    sudo python3 final.py
    python3 final.py --dry-run -v          # no UART writes, verbose logs
    python3 final.py --serial /dev/ttyUSB0 # USB-to-serial adapter
"""

import argparse
import json
import logging
import signal
import sys
import time
from contextlib import contextmanager

try:
    import requests
except ImportError:
    sys.exit("Missing: pip install requests pyserial")

try:
    import serial
except ImportError:
    sys.exit("Missing: pip install requests pyserial")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
FIREBASE_BASE      = "https://lab1-f7c43-default-rtdb.firebaseio.com"
TELEMETRY_PATH     = f"{FIREBASE_BASE}/car_telemetry.json"
EYE_MONITOR_PATH   = f"{FIREBASE_BASE}/eye_monitor.json"

DEFAULT_SERIAL     = "/dev/serial0"
BAUD               = 9600

POLL_INTERVAL_S    = 0.1          # 10 Hz loop
EYE_POLL_INTERVAL_S = 0.5         # check eye monitor every 500 ms
STALE_EYE_MS       = 2000         # eye data older than this → send 'C'
NET_TIMEOUT_S      = 2.0

CMD_AWAKE = b"E"
CMD_SLEEP = b"C"

log = logging.getLogger("final")

# ---------------------------------------------------------------------------
# UART helpers
# ---------------------------------------------------------------------------
@contextmanager
def open_serial(dev, dry_run):
    if dry_run:
        log.info("DRY RUN: UART not opened (%s)", dev)
        yield None
        return
    ser = serial.Serial(dev, BAUD, timeout=0.2)
    try:
        yield ser
    finally:
        try:
            ser.close()
        except Exception:
            pass


def uart_write(ser, cmd: bytes):
    if ser is None:
        return True
    try:
        ser.write(cmd)
        ser.flush()
        return True
    except serial.SerialException as exc:
        log.warning("UART write error: %s", exc)
        return False


def uart_readline(ser) -> str:
    """Read one line from UART; return empty string on timeout/error."""
    if ser is None:
        return ""
    try:
        raw = ser.readline()
        return raw.decode("ascii", errors="ignore").strip()
    except serial.SerialException as exc:
        log.warning("UART read error: %s", exc)
        return ""


# ---------------------------------------------------------------------------
# Telemetry parser  –  "F:045 R:180 L:200 D:0 B:1"
# ---------------------------------------------------------------------------
def parse_pic_line(line: str):
    """Return dict with keys front, right, left, door, belt or None on error."""
    try:
        parts = {}
        for token in line.split():
            if ":" in token:
                k, v = token.split(":", 1)
                parts[k.upper()] = int(v)
        if not {"F", "R", "L", "D", "B"}.issubset(parts):
            return None
        return {
            "front": parts["F"],
            "right": parts["R"],
            "left":  parts["L"],
            "door":  "CLOSED" if parts["D"] == 0 else "OPEN",
            "belt":  "FASTENED" if parts["B"] == 1 else "UNBUCKLED",
            "timestamp": {".sv": "timestamp"},
        }
    except (ValueError, KeyError):
        return None


# ---------------------------------------------------------------------------
# Firebase push
# ---------------------------------------------------------------------------
def push_telemetry(data: dict, last_push_time: float, interval: float):
    """Rate-limited push to Firebase /car_telemetry."""
    now = time.time()
    if now - last_push_time < interval:
        return last_push_time
    try:
        r = requests.put(TELEMETRY_PATH, json=data, timeout=NET_TIMEOUT_S)
        r.raise_for_status()
        return now
    except Exception as exc:
        log.warning("Firebase push error: %s", exc)
        return last_push_time


# ---------------------------------------------------------------------------
# Eye-monitor read (mirrors eye_to_pic.py logic)
# ---------------------------------------------------------------------------
def fetch_eye_command():
    """Return (CMD_AWAKE or CMD_SLEEP, reason_str)."""
    try:
        r = requests.get(EYE_MONITOR_PATH, timeout=NET_TIMEOUT_S)
        r.raise_for_status()
        d = r.json() or {}
        state  = d.get("state")
        ts_ms  = int(d.get("timestamp", 0)) or None
        now_ms = int(time.time() * 1000)
        age_ms = (now_ms - ts_ms) if ts_ms is not None else None

        if age_ms is None or age_ms > STALE_EYE_MS:
            return CMD_SLEEP, f"stale({age_ms}ms)"
        if state == "OPEN":
            return CMD_AWAKE, "awake"
        return CMD_SLEEP, f"eye-state={state}"
    except Exception as exc:
        log.warning("Eye-monitor fetch error: %s", exc)
        return CMD_SLEEP, f"fetch-error"


# ---------------------------------------------------------------------------
# Safe-stop signal handler
# ---------------------------------------------------------------------------
def make_safe_stop(ser):
    def handler(signum=None, frame=None):
        log.info("Shutting down – sending final 'C' to PIC")
        uart_write(ser, CMD_SLEEP)
        try:
            requests.put(
                TELEMETRY_PATH,
                json={"shutdown": True, "timestamp": {".sv": "timestamp"}},
                timeout=NET_TIMEOUT_S,
            )
        except Exception:
            pass
        sys.exit(0)
    return handler


# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--serial",  default=DEFAULT_SERIAL,
                        help=f"UART device (default {DEFAULT_SERIAL})")
    parser.add_argument("--dry-run", action="store_true",
                        help="no UART writes; simulated PIC data")
    parser.add_argument("--verbose", "-v", action="store_true")
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="[%(asctime)s] %(levelname)s %(message)s",
        datefmt="%H:%M:%S",
    )

    with open_serial(args.serial, args.dry_run) as ser:
        safe_stop = make_safe_stop(ser)
        signal.signal(signal.SIGINT,  safe_stop)
        signal.signal(signal.SIGTERM, safe_stop)

        log.info(
            "final.py online | serial=%s | dry_run=%s | loop=%.0fHz",
            args.serial, args.dry_run, 1.0 / POLL_INTERVAL_S,
        )

        last_tel_push    = 0.0
        last_eye_check   = 0.0
        last_eye_cmd     = None
        tel_push_interval = 0.2   # max 5 Firebase pushes/sec for telemetry

        sim_counter = 0           # only used in --dry-run mode

        while True:
            loop_start = time.time()

            # ── 1. Read PIC UART line ─────────────────────────────────────
            if args.dry_run:
                # Simulate PIC output for testing
                sim_counter += 1
                line = f"F:{40+sim_counter%60:03d} R:{150+sim_counter%100:03d} L:{120+sim_counter%80:03d} D:0 B:1"
                time.sleep(0.05)
            else:
                line = uart_readline(ser)

            if line:
                data = parse_pic_line(line)
                if data:
                    log.debug("PIC ← %s | parsed=%s", line, data)
                    last_tel_push = push_telemetry(data, last_tel_push, tel_push_interval)
                else:
                    log.debug("PIC raw (unparsed): %s", line)

            # ── 2. Eye-monitor relay ──────────────────────────────────────
            if loop_start - last_eye_check >= EYE_POLL_INTERVAL_S:
                eye_cmd, reason = fetch_eye_command()
                last_eye_check = loop_start

                if eye_cmd != last_eye_cmd:
                    if uart_write(ser, eye_cmd):
                        log.info(
                            "Eye command → %s (%s)",
                            eye_cmd.decode(), reason,
                        )
                        last_eye_cmd = eye_cmd

            # ── 3. Pace the loop ─────────────────────────────────────────
            elapsed = time.time() - loop_start
            sleep_s = POLL_INTERVAL_S - elapsed
            if sleep_s > 0:
                time.sleep(sleep_s)


if __name__ == "__main__":
    main()
