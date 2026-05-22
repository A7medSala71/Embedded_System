#!/usr/bin/env python3
"""
Lane center detection – two black duct tape strips on white tiles.
Pipeline: threshold → morph open → row scan → outlier rejection →
          weighted quadratic fit → EMA temporal smoothing → lane fill + centerline
Firebase: pushes lane_status (detected, offset, timestamp) to Realtime Database
"""
import cv2
import numpy as np
from picamera2 import Picamera2
import firebase_admin
from firebase_admin import credentials, db as firebase_db
import time

# ---------------------------------------------------------------------------
# Firebase Setup — reads service_key.json from the same folder as this script
# ---------------------------------------------------------------------------
DATABASE_URL = "https://lab1-f7c43-default-rtdb.firebaseio.com"

# How often to push to Firebase (seconds). 0.2 = max 5 times/sec
FIREBASE_PUSH_INTERVAL = 0.2

# ---------------------------------------------------------------------------
# Tunable parameters
# ---------------------------------------------------------------------------
FRAME_W, FRAME_H = 640, 480

DARK_THRESHOLD    = 90    # pixels darker than this = tape
MORPH_KSIZE       = 15    # must be wider than grout lines, narrower than tape
ROI_TOP_FRAC      = 0.10  # how far up the frame to look
ROW_STEP          = 7     # sample every N rows

MIN_POINTS        = 10
MIN_LANE_WIDTH_PX = 40

EMA_ALPHA = 0.20

LANE_FILL_COLOR  = (0, 210, 90)
LANE_FILL_ALPHA  = 0.40
CENTER_COLOR     = (0, 255, 0)
CENTER_THICKNESS = 2

_ema_coeffs = None


# ---------------------------------------------------------------------------
# Firebase helpers
# ---------------------------------------------------------------------------

def init_firebase():
    cred = credentials.Certificate("service_key.json")
    firebase_admin.initialize_app(cred, {"databaseURL": DATABASE_URL})
    ref  = firebase_db.reference("lane_status")
    print(f"[Firebase] Connected → {DATABASE_URL}/lane_status")
    return ref


def push_lane_status(lane_ref, detected: bool, offset, last_push_time: float):
    """Push to Firebase only if enough time has passed (rate limiter)."""
    now = time.time()
    if now - last_push_time < FIREBASE_PUSH_INTERVAL:
        return last_push_time  # skip this frame

    payload = {
        "detected" : detected,
        "offset"   : offset if offset is not None else 0,
        "timestamp": {".sv": "timestamp"},  # server-side timestamp
    }
    try:
        lane_ref.set(payload)
    except Exception as e:
        print(f"[Firebase] Push error: {e}")
    return now


# ---------------------------------------------------------------------------
# Vision pipeline
# ---------------------------------------------------------------------------

def preprocess(frame):
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    _, binary = cv2.threshold(gray, DARK_THRESHOLD, 255, cv2.THRESH_BINARY_INV)
    k = cv2.getStructuringElement(cv2.MORPH_RECT, (MORPH_KSIZE, MORPH_KSIZE))
    return cv2.morphologyEx(binary, cv2.MORPH_OPEN, k)


def find_lane_data(tape_mask):
    """
    Scan rows from bottom to ROI top.
    Find the LARGEST gap between tape regions — that gap is the lane opening.
    """
    h, w    = tape_mask.shape
    roi_top = int(h * ROI_TOP_FRAC)

    centre_pts = []
    edge_pts   = []

    for y in range(h - 1, roi_top, -ROW_STEP):
        cols = np.where(tape_mask[y] > 0)[0]
        if len(cols) < 2:
            continue

        diffs    = np.diff(cols)
        gap_idxs = np.where(diffs > 5)[0]
        if not len(gap_idxs):
            continue

        best   = gap_idxs[np.argmax(diffs[gap_idxs])]
        li, ri = int(cols[best]), int(cols[best + 1])

        if ri - li < MIN_LANE_WIDTH_PX:
            continue

        centre_pts.append(((li + ri) // 2, y))
        edge_pts.append((li, ri, y))

    return centre_pts, edge_pts


def reject_outliers(pts):
    """Remove centre points whose x deviates too far from the median."""
    if len(pts) < 4:
        return pts
    xs     = np.array([p[0] for p in pts], dtype=float)
    median = np.median(xs)
    mad    = np.median(np.abs(xs - median))
    tol    = max(3.5 * mad, 15)
    return [p for p in pts if abs(p[0] - median) <= tol]


def fit_centre_line(centre_pts):
    """
    Weighted quadratic fit x = f(y), then EMA-smooth the coefficients.
    Bottom rows weighted more: closer to camera, less perspective warp.
    """
    global _ema_coeffs

    centre_pts = reject_outliers(centre_pts)
    if len(centre_pts) < MIN_POINTS:
        _ema_coeffs = None
        return None

    ys     = np.array([p[1] for p in centre_pts], dtype=np.float32)
    xs     = np.array([p[0] for p in centre_pts], dtype=np.float32)
    w      = ys / FRAME_H
    coeffs = np.polyfit(ys, xs, 2, w=w)

    if _ema_coeffs is not None:
        coeffs = EMA_ALPHA * coeffs + (1.0 - EMA_ALPHA) * _ema_coeffs
    _ema_coeffs = coeffs

    roi_top = int(FRAME_H * ROI_TOP_FRAC)
    y_vals  = np.arange(FRAME_H - 1, roi_top, -2)
    x_vals  = np.clip(np.polyval(coeffs, y_vals).astype(int), 0, FRAME_W - 1)
    return np.column_stack((x_vals, y_vals))


def build_lane_fill(edge_pts):
    """Filled polygon between the inner edges of the two tape strips."""
    if len(edge_pts) < 3:
        return None
    left_side  = [(li, y) for li, ri, y in edge_pts]
    right_side = [(ri, y) for li, ri, y in edge_pts[::-1]]
    poly = np.array(left_side + right_side, dtype=np.int32)
    fill = np.zeros((FRAME_H, FRAME_W, 3), dtype=np.uint8)
    cv2.fillPoly(fill, [poly], LANE_FILL_COLOR)
    return fill


def draw_output(frame, tape_mask, smooth_pts, raw_pts, edge_pts):
    out = frame.copy()

    # 1. Lane fill
    fill = build_lane_fill(edge_pts)
    if fill is not None:
        out = cv2.addWeighted(out, 1.0, fill, LANE_FILL_ALPHA, 0)

    # 2. Tape tint
    tint = np.zeros_like(frame)
    tint[tape_mask > 0] = (140, 40, 0)
    out = cv2.addWeighted(out, 1.0, tint, 0.18, 0)

    # 3. Raw midpoint dots
    for x, y in raw_pts:
        cv2.circle(out, (x, y), 2, (0, 210, 255), -1)

    # 4. Smooth centre line + offset label
    if smooth_pts is not None and len(smooth_pts) > 1:
        cv2.polylines(out, [smooth_pts.reshape(-1, 1, 2)],
                      False, CENTER_COLOR, CENTER_THICKNESS)

        tx = int(smooth_pts[-1][0])
        cv2.circle(out, (tx, FRAME_H - 6), 8, (0, 0, 255), -1)
        cv2.line(out, (FRAME_W // 2, FRAME_H - 6), (tx, FRAME_H - 6),
                 (0, 0, 255), 1)

        offset      = tx - FRAME_W // 2
        label_color = (0, 255, 0) if abs(offset) < 25 else (0, 140, 255)
        cv2.putText(out, f"offset {offset:+d} px", (10, FRAME_H - 12),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.55, label_color, 1)
    else:
        cv2.putText(out, "LANE NOT FOUND",
                    (FRAME_W // 2 - 100, FRAME_H // 2),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 2)

    # 5. ROI horizon line
    cv2.line(out, (0, int(FRAME_H * ROI_TOP_FRAC)),
             (FRAME_W, int(FRAME_H * ROI_TOP_FRAC)), (200, 100, 0), 1)

    cv2.putText(out, "q = quit", (FRAME_W - 72, 20),
                cv2.FONT_HERSHEY_SIMPLEX, 0.45, (180, 180, 180), 1)
    return out


# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

def main():
    # Init Firebase
    lane_ref  = init_firebase()
    last_push = 0.0

    # Init camera
    cam = Picamera2()
    cam.configure(cam.create_preview_configuration(
        main={"format": "BGR888", "size": (FRAME_W, FRAME_H)}
    ))
    cam.start()
    print("Running – press 'q' or Ctrl-C to stop.")

    try:
        while True:
            frame             = cam.capture_array()
            tape_mask         = preprocess(frame)
            raw_pts, edge_pts = find_lane_data(tape_mask)
            smooth_pts        = fit_centre_line(raw_pts)
            out               = draw_output(frame, tape_mask, smooth_pts,
                                            raw_pts, edge_pts)

            # ── Push lane status to Firebase ──────────────────────────────
            if smooth_pts is not None and len(smooth_pts) > 1:
                offset    = int(smooth_pts[-1][0]) - FRAME_W // 2
                last_push = push_lane_status(lane_ref, True, offset, last_push)
            else:
                last_push = push_lane_status(lane_ref, False, None, last_push)

            cv2.imshow("Lane Center", out)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    except KeyboardInterrupt:
        pass

    finally:
        # Mark lane as not detected on clean shutdown
        try:
            lane_ref.set({
                "detected" : False,
                "offset"   : 0,
                "timestamp": {".sv": "timestamp"}
            })
        except Exception:
            pass
        cam.stop()
        cv2.destroyAllWindows()
        print("Stopped.")


if __name__ == "__main__":
    main()
