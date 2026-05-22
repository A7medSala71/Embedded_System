# 🚗 Autonomous Safety RC Car — PIC16F877A + Raspberry Pi + Firebase

A fully autonomous RC car with layered driver-safety interlocks, real-time cloud telemetry, and a lane-detection vision pipeline. The system integrates a PIC16F877A microcontroller, a Raspberry Pi, an Android eye-monitoring app, and a Next.js dashboard — all communicating through Firebase Realtime Database.

---

## 📸 Hardware

| Top View | Side View | Front View |
|----------|-----------|------------|
| ![Car top](docs/images/car2.png) | ![Car side](docs/images/car1.png) | ![Car front](docs/images/car3.png) |

| Custom PCB | Schematic |
|------------|-----------|
| ![PCB](docs/images/pcb.png) | ![Schematic](docs/images/schematic.png) |

---

## ✨ Features

- **Autonomous obstacle avoidance** — 3× HC-SR04 ultrasonic sensors (Front / Left / Right) with no servo conflicts
- **4-layer safety state machine** — Door open → No seatbelt → Eyes closed → Safe; motors kill on any unsafe condition
- **Drowsy-driver detection** — Android app monitors driver eyes via ML and pushes state to Firebase; Raspberry Pi relays commands to PIC via UART
- **Lane-centre detection** — Raspberry Pi camera detects black duct-tape lane markings and pushes offset to Firebase in real time
- **Live telemetry dashboard** — Next.js web app displays distance readings, safety status, drive mode, and eye-state
- **UART data logging** — `final.py` bridges PIC ↔ Firebase bidirectionally (telemetry up, eye commands down)
- **Custom PCB** — All logic on a single board designed in EasyEDA

---

## 🏗️ Repository Structure

```
RC_Car_Project/
├── APP/
│   └── main.c                    # PIC firmware (final active version)
├── HAL/
│   ├── Bluetooth/
│   │   ├── Bluetooth.c           # Structured ASCII packet sender
│   │   └── Bluetooth.h
│   ├── HC-SR04/
│   │   ├── SR04.c                # 3-sensor ultrasonic driver
│   │   └── SR04.h
│   ├── LCD/
│   │   ├── LCD.c                 # I2C PCF8574 backpack driver
│   │   └── LCD.h
│   ├── Motor/
│   │   ├── Motor.c               # L298N H-bridge driver
│   │   └── Motor_interface.h
│   └── Switch/
│       ├── Switch.c
│       └── Switch_interface.h
├── MCAL/
│   ├── EXT_INT/                  # External interrupt driver
│   ├── GPIO/                     # GPIO abstraction layer
│   ├── I2C/                      # I2C (master mode, PCF8574 LCD)
│   ├── Interrupt_Manager/        # Centralized ISR routing
│   ├── PWM/                      # Timer1 PWM (servo, optional)
│   ├── TMR1/                     # Timer 1 driver
│   └── UART/
│       ├── UART_interface.c      # 9600-baud USART driver
│       └── UART_interface.h
├── SERVICES/
│   ├── BIT_MATH.h                # Bit manipulation macros
│   ├── config.h                  # PIC config bits & _XTAL_FREQ
│   └── STD_TYPES.h               # u8 / u16 / u32 typedefs
├── RC_Car_Final.X/               # MPLAB X project (build artifacts)
│   └── dist/default/production/
│       └── RC_Car_Final.X.production.hex   ← flash this to the PIC
└── PROJECT_GUIDE.md              # Full wiring & architecture reference

rc-car-dashboard/                 # Next.js real-time web dashboard
├── app/
├── components/
│   └── rc-car-dashboard.tsx
└── ...

eye_to_pic.py                     # Pi bridge: Firebase eye_monitor → PIC UART
lane_detection_firebase.py        # Pi vision: camera lane detection → Firebase
final.py                          # Pi bridge: PIC UART telemetry → Firebase + eye relay
```

---

## 🔌 Pin Connections (PIC16F877A)

### Motor Driver (L298N)

| PIC Pin | L298N Pin | Function |
|---------|-----------|----------|
| RD4 | IN1 | Motor A (Left) forward |
| RD5 | IN2 | Motor A (Left) reverse |
| RD6 | IN3 | Motor B (Right) forward |
| RD7 | IN4 | Motor B (Right) reverse |

### Ultrasonic Sensors (HC-SR04 ×3)

| Sensor | TRIG Pin | ECHO Pin |
|--------|----------|----------|
| Front  | RB1      | RB2      |
| Left   | RD0      | RD1      |
| Right  | RB3      | RB4      |

### LCD (I2C PCF8574 Backpack)

| Signal | PIC Pin | Pull-up |
|--------|---------|---------|
| SDA    | RC4     | 4.7 kΩ to VCC |
| SCL    | RC3     | 4.7 kΩ to VCC |

### Bluetooth / UART (HC-05 or Raspberry Pi serial)

| Signal | PIC Pin | Notes |
|--------|---------|-------|
| TX     | RC6     | 1kΩ+2kΩ divider to protect 3.3V targets |
| RX     | RC7     | 3.3V from HC-05 is PIC-safe |

### Safety Sensors

| Sensor | PIC Pin | Logic |
|--------|---------|-------|
| Magnetic door switch | RA0 | 0 = closed (safe), 1 = open (danger) |
| Seatbelt switch      | RA1 | 0 = unbuckled (danger), 1 = fastened (safe) |

---

## 🧠 Firmware State Machine

```
                    ┌──────────────────────────────────┐
  UART 'E' ────────►│          STATE_SAFE              │◄──── door closed
  eyes open          │  Autonomous obstacle avoidance   │      belt fastened
                    │  LCD: F:xx L:xx R:xx             │      eyes open
                    └────────────┬─────────────────────┘
                                 │  any unsafe event
          ┌──────────────────────┼──────────────────────┐
          ▼                      ▼                       ▼
 STATE_DOOR_OPEN      STATE_NO_BELT          STATE_EYES_CLOSED
 Motor_Stop()          Motor_Stop()           Motor_Stop()
 "!! DOOR OPEN !!"    "!! NO SEATBELT !"     "!! DROWSY DRIVER"
```

Priority: DOOR_OPEN > NO_BELT > EYES_CLOSED > SAFE

---

## 🐍 Raspberry Pi Scripts

### `final.py` — Main Bridge (run this in production)

Reads PIC UART telemetry and pushes to Firebase `/car_telemetry`.  
Also polls `/eye_monitor` and relays `'E'`/`'C'` commands to the PIC.

```bash
sudo python3 final.py                        # production
python3 final.py --dry-run -v               # test without hardware
python3 final.py --serial /dev/ttyUSB0      # USB-serial adapter
```

### `eye_to_pic.py` — Standalone Eye Relay

Polls Firebase `/eye_monitor` (published by Android app) and sends UART commands to PIC. Use this if `final.py` is not running.

```bash
sudo python3 eye_to_pic.py
python3 eye_to_pic.py --dry-run -v
```

### `lane_detection_firebase.py` — Lane Vision

Uses PiCamera2 + OpenCV to detect black duct-tape lane markings and push offset to Firebase `/lane_status`.

```bash
python3 lane_detection_firebase.py
```

**Dependencies:**

```bash
pip install requests pyserial firebase-admin opencv-python picamera2
```

---

## 🌐 Firebase Realtime Database Schema

```json
{
  "car_telemetry": {
    "front":     45,
    "left":      200,
    "right":     180,
    "door":      "CLOSED",
    "belt":      "FASTENED",
    "timestamp": 1716300000000
  },
  "eye_monitor": {
    "state":     "OPEN",
    "p_open":    0.94,
    "p_closed":  0.06,
    "fps":       12.5,
    "timestamp": 1716300000100
  },
  "lane_status": {
    "detected":  true,
    "offset":    -12,
    "timestamp": 1716300000200
  }
}
```

---

## 🖥️ Dashboard (Next.js)

```bash
cd rc-car-dashboard
pnpm install
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000)

The dashboard reads all three Firebase paths above and displays them live.

---

## ⚡ Flashing the PIC

1. Open `RC_Car_Final.X` in **MPLAB X IDE**
2. Connect a PICkit 3/4 programmer
3. Build → Program (`RC_Car_Final.X.production.hex` is pre-built in `dist/`)
4. Crystal: **20 MHz HS**; config bits are set in `SERVICES/config.h`

---

## 🔋 Power Supply

| Channel | Voltage | Powers |
|---------|---------|--------|
| Ch. 1   | +5V     | PIC, HC-SR04 ×3, LCD, HC-05, Raspberry Pi |
| Ch. 2   | +5–12V  | L298N motor supply |
| Ch. 3   | +5V     | Servo (optional, separate from PIC rail) |

> **All channels share a common GND.**  
> Place 100 nF ceramic caps close to PIC VDD, each HC-SR04, and the PCF8574.  
> Place a 100 µF electrolytic cap at the L298N motor supply input.

---

## 📋 UART Command Reference

| Byte | Sent by | Effect on PIC |
|------|---------|---------------|
| `'E'` | Raspberry Pi (eye relay) | `eyes_open = 1` → allows AUTO mode |
| `'C'` | Raspberry Pi (eye relay) | `eyes_open = 0` → STATE_EYES_CLOSED, Motor_Stop() |
| `'A'` | Dashboard / Pi | Switch to AUTO (autonomous) mode |
| `'M'` | Dashboard / Pi | Switch to MANUAL mode |
| `'F'` | Manual mode only | Motor_Forward() |
| `'B'` | Manual mode only | Motor_Reverse() |
| `'L'` | Manual mode only | Motor_Turn_Left() |
| `'R'` | Manual mode only | Motor_Turn_Right() |
| `'S'` | Manual mode only | Motor_Stop() |

PIC sends every ~100 ms: `F:045 R:180 L:200 D:0 B:1\n`

---

## 👥 Authors

- **s-ahmed.elabd** — hardware, PCB design, PIC firmware
- Schematic & PCB drawn in **EasyEDA** (2026-05-06)

---

## 📄 License

This project is for educational purposes.
