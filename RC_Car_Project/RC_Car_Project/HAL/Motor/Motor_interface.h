/**
 * @file Motor_interface.h
 * @brief DC Motor driver via L298N H-Bridge
 *
 * PIN ASSIGNMENT (L298N):
 *   RD4 = IN1  (Motor A direction bit 0)
 *   RD5 = IN2  (Motor A direction bit 1)
 *   RD6 = IN3  (Motor B direction bit 0)
 *   RD7 = IN4  (Motor B direction bit 1)
 *
 * ENA and ENB on L298N should be tied HIGH (no PWM speed control)
 * unless Motor_SetSpeed() is implemented with CCP hardware PWM.
 *
 * Motor A = Left wheels
 * Motor B = Right wheels
 */

#ifndef MOTOR_INTERFACE_H
#define MOTOR_INTERFACE_H

#include "../../SERVICES/STD_TYPES.h"

void Motor_Init(void);
void Motor_Stop(void);
void Motor_Forward(void);
void Motor_Reverse(void);
void Motor_Turn_Left(void);
void Motor_Turn_Right(void);
void Motor_SetSpeed(u8 duty_cycle);   /* stub — extend with CCP PWM */

#endif
