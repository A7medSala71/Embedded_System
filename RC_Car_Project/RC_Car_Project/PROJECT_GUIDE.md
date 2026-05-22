# Autonomous RC Car — PIC16F877A
## Complete Technical Guide: Code Review, Updates & Wiring

---

## 1. WHAT CHANGED IN THE DRIVERS (and Why)

### 1.1 Core Problem You Identified — Servo Current Spikes

Your diagnosis was correct. A single servo on the scan-and-navigate path causes
two problems simultaneously:
- **Inrush current spike** each time the servo moves to a new angle (motors + servo
  sharing the same rail causes voltage dips → erratic motor behavior).
- **Timer1 conflict**: your SR04 echo timing and your servo ISR both need Timer1.
  The old code had a race condition — if an echo pulse arrived while the ISR was
  reloading TMR1, you got garbage distance readings.

**Solution chosen: 3 fixed ultrasonic sensors (no servo).**
This eliminates both problems: no inrush spikes, and the 3 sensors always have
"eyes" in all directions simultaneously. The servo code is retained in the project
but is only activated if you want to revert.

---

### 1.2 File-by-File Change Summary

| File | Status | Key Changes |
|---|---|---|
| `MCAL/PWM/PWM_interface.c` | **Updated** | Added `PWM_voidDisableServoISR()` / `PWM_voidEnableServoISR()` so SR04 can safely suspend the Timer1 ISR during echo measurement |
| `MCAL/PWM/PWM_interface.h` | **Updated** | Added the two new function declarations |
| `MCAL/UART/UART_interface.c` | **NEW** | Full USART driver for HC-05 Bluetooth at 9600 baud |
| `MCAL/UART/UART_interface.h` | **NEW** | USART API header |
| `MCAL/Interrupt_Manager/Interrupt_manager.c` | **Updated** | Added INT0 (door switch) ISR hook; servo ISR preserved |
| `HAL/HC-SR04/SR04.c` | **Rewritten** | 3-sensor support (FRONT/LEFT/RIGHT); software timing loop (no Timer1 race); calls `PWM_voidDisableServoISR()` before each pulse |
| `HAL/HC-SR04/SR04.h` | **Updated** | Added sensor ID defines |
| `HAL/Motor/Motor.c` | **Updated** | Added `Motor_Reverse()`; fixed PORTD init to preserve lower nibble (SR04 pins RD0–RD3) |
| `HAL/Motor/Motor_interface.h` | **Updated** | Added `Motor_Reverse()` prototype |
| `HAL/Bluetooth/Bluetooth.c` | **NEW** | Structured ASCII log packet sender |
| `HAL/Bluetooth/Bluetooth.h` | **NEW** | Bluetooth HAL API + state string defines |
| `APP/main.c` | **Rewritten** | Full system integration: safety interlocks → obstacle avoidance → BT logging |
| `HAL/Switch/*`, `HAL/LCD/*`, `MCAL/GPIO/*`, `MCAL/I2C/*`, `MCAL/TMR1/*` | **Unchanged** | Verified compatible |

---

## 2. PIN ASSIGNMENT TABLE

```
PIC16F877A Pin   Direction   Connected To                     Notes
─────────────────────────────────────────────────────────────────────────
RA0 / AN0        INPUT       Magnetic door switch             Pull-up 10k to VCC
RA1 / AN1        INPUT       Seatbelt push-button             Pull-up 10k to VCC
─────────────────────────────────────────────────────────────────────────
RC0              OUTPUT      HC-SR04 FRONT — TRIG
RC1              INPUT       HC-SR04 FRONT — ECHO
RC2 / CCP1       OUTPUT      Servo signal (optional, ISR)     Timer1 software PWM
RC3              I2C SCL     PCF8574 LCD backpack SCL
RC4              I2C SDA     PCF8574 LCD backpack SDA
RC6              UART TX     HC-05 Bluetooth — RXD pin        Set by USART peripheral
RC7              UART RX     HC-05 Bluetooth — TXD pin        Set by USART peripheral
─────────────────────────────────────────────────────────────────────────
RD0              OUTPUT      HC-SR04 LEFT  — TRIG
RD1              INPUT       HC-SR04 LEFT  — ECHO
RD2              OUTPUT      HC-SR04 RIGHT — TRIG
RD3              INPUT       HC-SR04 RIGHT — ECHO
RD4              OUTPUT      L298N IN1  (Motor A, left)
RD5              OUTPUT      L298N IN2  (Motor A, left)
RD6              OUTPUT      L298N IN3  (Motor B, right)
RD7              OUTPUT      L298N IN4  (Motor B, right)
─────────────────────────────────────────────────────────────────────────
VDD (pins 11,32) —           +5V regulated
VSS (pins 12,31) —           Common GND
OSC1 (pin 13)    —           20 MHz crystal
OSC2 (pin 14)    —           20 MHz crystal
MCLR (pin 1)     —           10k pull-up to VCC + 100nF to GND
```

---

## 3. POWER SUPPLY WIRING (3-Channel PSU, Common Ground)

```
Channel 1 → +5V  (PIC, HC-SR04 sensors ×3, LCD I2C backpack, HC-05 VCC)
Channel 2 → +5V or +12V  (L298N motor supply — depends on your motors)
Channel 3 → +5V  (Servo, if still used — SEPARATE from motor channel)

All channel GND terminals → common GND bus (one thick wire or PCB ground plane)
```

**Why separate channels?**

- Motors and the L298N are noisy; their switching transients on the 5V rail
  cause PIC resets and corrupted I2C/UART data.
- Servo inrush (up to 1A peak) must not share the PIC+sensor 5V rail.
- The three HC-SR04 sensors together draw ≈ 45 mA steady-state; this is fine
  on the same 5V rail as the PIC.

**Decoupling capacitors (mandatory):**

Place these physically close to the IC pins, not at the power supply:

```
100 nF ceramic — between PIC VDD and GND (pins 11/32 area)
100 nF ceramic — between each HC-SR04 VCC and GND (one per sensor)
100 nF ceramic — between PCF8574 (LCD backpack) VCC and GND
100 uF electrolytic — at L298N motor VCC input (bulk filter)
```

---

## 4. COMPONENT WIRING — STEP BY STEP

### 4.1 Magnetic Door Switch (PORTA.0)

```
Switch terminal 1 ──── RA0 (PIC pin 2) ──── 10k ──── +5V
Switch terminal 2 ──── GND

Logic: magnet present (door closed) → switch contacts closed → RA0 = LOW (0)
       magnet absent  (door open)   → contacts open          → RA0 = HIGH (1) via pull-up
```

### 4.2 Seatbelt Push-Button (PORTA.1)

```
Button terminal 1 ──── RA1 (PIC pin 3) ──── 10k ──── +5V
Button terminal 2 ──── GND

Logic: button pressed (belt on) → RA1 = LOW (0)
       button released          → RA1 = HIGH (1) via pull-up
```

Add 100 nF debounce capacitor from RA1 to GND if you get erratic readings.

### 4.3 HC-SR04 Ultrasonic Sensors

Wire all three identically; only the PIC pins differ:

```
HC-SR04     PIC pin       Function
VCC    ──── +5V (Ch.1)
GND    ──── Common GND
TRIG   ──── RC0 / RD0 / RD2   (FRONT / LEFT / RIGHT)
ECHO   ──── RC1 / RD1 / RD3   (FRONT / LEFT / RIGHT)
```

**Echo voltage divider (important!):**
HC-SR04 ECHO outputs 5V logic. PIC I/O is 5V tolerant on most pins, but
add a 1kΩ + 2kΩ resistor divider on each ECHO line for safety:

```
HC-SR04 ECHO ── 1kΩ ── PIC ECHO pin
                         │
                        2kΩ
                         │
                        GND
```
This gives ≈ 3.3V at the PIC input — safe on all PIC16F877A pins.

### 4.4 LCD (I2C PCF8574 backpack)

```
PCF8574 Module   PIC pin
VCC        ──── +5V (Ch.1)
GND        ──── Common GND
SDA        ──── RC4 (PIC pin 23)   with 4.7kΩ pull-up to +5V
SCL        ──── RC3 (PIC pin 18)   with 4.7kΩ pull-up to +5V
```

Check the solder-bridge jumpers on the PCF8574 backpack to confirm
I2C address = 0x27 (default, all A0/A1/A2 = 0).

### 4.5 L298N H-Bridge (DC Motors)

```
L298N terminal   Connected to
IN1        ──── RD4 (PIC pin 27)
IN2        ──── RD5 (PIC pin 28)
IN3        ──── RD6 (PIC pin 29)
IN4        ──── RD7 (PIC pin 30)
ENA        ──── +5V (tied HIGH for full speed — or CCP1 for PWM speed)
ENB        ──── +5V (tied HIGH for full speed — or CCP2 for PWM speed)
VCC (+12V) ──── Ch.2 motor supply (+5V to +12V)
GND        ──── Common GND
5V OUT     ──── DO NOT use to power PIC (it's for the logic supply only)

Motor A +  ──── Left wheel motor +
Motor A -  ──── Left wheel motor -
Motor B +  ──── Right wheel motor +
Motor B -  ──── Right wheel motor -
```

Place a 1N4007 flyback diode across each motor terminal if not already
on the L298N module (most breakout boards include them).

### 4.6 HC-05 Bluetooth Module

```
HC-05 pin    PIC pin        Notes
VCC   ──── +5V (Ch.1)      HC-05 runs on 3.3V internally but most modules
                             have a 3.3V regulator on-board; check your module
GND   ──── Common GND
TXD   ──── RC7 (UART RX)   Voltage: HC-05 TX is 3.3V — PIC RC7 is 5V tolerant ✓
RXD   ──── RC6 (UART TX)   PIC TX is 5V; add 1kΩ + 2kΩ divider to protect HC-05:
                             RC6 ── 1kΩ ── HC-05 RXD
                                            │
                                           2kΩ
                                            │
                                           GND
```

**Pairing the HC-05 to your laptop:**
1. Power the HC-05. Pair from your laptop's Bluetooth settings (default PIN: 1234 or 0000).
2. A new COM port will appear. Open with any serial terminal at **9600 baud, 8N1**.
3. You will see lines like: `DOOR:CLOSED,BELT:ON,FRONT:045,LEFT:200,RIGHT:180,STATE:MOVING`

---

## 5. SOFTWARE ARCHITECTURE DIAGRAM

```
┌──────────────────────────────────────────────────────────┐
│                        main.c (APP)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐  │
│  │  Safety  │  │ Obstacle │  │   LCD    │  │  Bluetooth│ │
│  │  Check   │  │  Avoid   │  │  Status  │  │  Logging │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
└───────┼─────────────┼─────────────┼──────────────┼────────┘
        │             │             │              │
   ┌────▼────┐  ┌─────▼─────┐ ┌────▼────┐   ┌────▼────┐
   │ Switch  │  │  SR04 HAL │ │LCD HAL  │   │  BT HAL │
   │  HAL   │  │ (3 sensor)│ │(I2C/PCF)│   │         │
   └────┬────┘  └─────┬─────┘ └────┬────┘   └────┬────┘
        │             │             │              │
   ┌────▼────┐  ┌─────▼─────┐ ┌────▼────┐   ┌────▼────┐
   │GPIO MCAL│  │PWM ISR    │ │I2C MCAL │   │UART MCAL│
   │         │  │(Timer1)   │ │         │   │         │
   └─────────┘  └───────────┘ └─────────┘   └─────────┘
                      │
               ┌──────▼───────┐
               │ Motor HAL    │
               │ (L298N RD4-7)│
               └──────────────┘
```

---

## 6. LCD STATUS MESSAGES

| Condition | Line 0 | Line 1 |
|---|---|---|
| Door open | `!! DOOR OPEN !!` | `Car is LOCKED` |
| Seatbelt not on | `!! NO SEATBELT !` | `Fasten belt 1st` |
| Obstacle front | `!OBSTACLE FRONT!` | `F:xx L:xx R:xx` |
| Turning left | `>> Turning LEFT` | *(retained)* |
| Turning right | `>> Turning RIGHT` | *(retained)* |
| Normal driving | `OK \| Moving Fwd` | `F:xx L:xx R:xx` |

---

## 7. BLUETOOTH LOG FORMAT

One line sent every 100 ms (10 Hz):

```
DOOR:CLOSED,BELT:ON,FRONT:045,LEFT:200,RIGHT:180,STATE:MOVING\r\n
```

Distance values are always 3 digits with leading zeros.
`999` means sensor timeout (no echo received within 30 ms).

**Python snippet to log to CSV on laptop:**

```python
import serial, csv, datetime

ser = serial.Serial('COM5', 9600, timeout=1)  # change COM port
with open('rc_log.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['time','door','belt','front','left','right','state'])
    while True:
        line = ser.readline().decode('ascii', errors='ignore').strip()
        if not line: continue
        fields = dict(p.split(':') for p in line.split(',') if ':' in p)
        writer.writerow([datetime.datetime.now().isoformat(),
                         fields.get('DOOR'),   fields.get('BELT'),
                         fields.get('FRONT'),  fields.get('LEFT'),
                         fields.get('RIGHT'),  fields.get('STATE')])
        print(line)
```

---

## 8. FUTURE: IF YOU WANT TO ADD SERVO BACK

The servo PWM ISR is preserved. To use single-servo + single-SR04 mode:

1. Restore the old `Navigation.c` logic.
2. Replace the 3-sensor calls in `main.c` with `Scan_Surroundings()`.
3. The `PWM_voidDisableServoISR()` / `PWM_voidEnableServoISR()` calls in
   `SR04.c` ensure the Timer1 ISR is safely paused during echo timing.
4. Use a higher-torque servo with external 5V/2A supply on a dedicated
   power channel (never share with PIC or motor rail).

---

*End of document. Files: RC_Car_Project.zip*
