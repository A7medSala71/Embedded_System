/**
 * @file PWM_interface.h
 * @brief Software PWM for Servo via Timer1 ISR  (PIC16F877A @ 20 MHz)
 *
 * Timer1 prescaler 1:8  -> tick = 1.6 us
 * 20 ms period  = 12 500 ticks
 * 1 ms pulse    =    625 ticks
 * 2 ms pulse    =  1 250 ticks
 *
 * IMPORTANT: Timer1 is SHARED with SR04 echo timing.
 *   - While servo ISR owns Timer1, SR04 must NOT attempt its own
 *     timer capture.  SR04_GetDistance() disables the servo ISR,
 *     takes its reading with a software loop, then re-enables it.
 *   - Call PWM_voidDisableServoISR() before SR04 measurement and
 *     PWM_voidEnableServoISR() after.
 */

#ifndef PWM_INTERFACE_H
#define PWM_INTERFACE_H

#include "../../SERVICES/STD_TYPES.h"

void PWM_voidInitServo(void);
void PWM_SetServoAngle(u8 angle);
void PWM_voidServoISR(void);

/* Suspend / resume the servo ISR to allow SR04 to use Timer1 */
void PWM_voidDisableServoISR(void);
void PWM_voidEnableServoISR(void);

/* Motor speed stub (no hardware PWM channel used for motors here) */
void PWM_SetMotorSpeed(u8 duty);

#endif
