/**
 * @file Motor.c
 * @brief DC Motor driver — full-speed digital direction control
 *
 * L298N truth table (IN1/IN2 = Motor A, IN3/IN4 = Motor B):
 *   IN1 IN2  Motor A    IN3 IN4  Motor B
 *    1   0   Forward     1   0   Forward
 *    0   1   Reverse     0   1   Reverse
 *    0   0   Stop        0   0   Stop
 *    1   1   Brake       1   1   Brake
 */

#include "Motor_interface.h"
#include <xc.h>

/* Convenience macros for H-Bridge control bits */
#define IN1  PORTDbits.RD4
#define IN2  PORTDbits.RD5
#define IN3  PORTDbits.RD6
#define IN4  PORTDbits.RD7

void Motor_Init(void)
{
    /* RD4..RD7 as digital outputs; RD0..RD3 left for SR04 ECHO/TRIG */
    TRISDbits.TRISD4 = 0;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    TRISDbits.TRISD7 = 0;
    PORTD &= 0x0F;   /* clear only upper nibble                       */
}

void Motor_Stop(void)
{
    IN1 = 0; IN2 = 0;
    IN3 = 0; IN4 = 0;
}

void Motor_Forward(void)
{
    IN1 = 1; IN2 = 0;
    IN3 = 1; IN4 = 0;
}

void Motor_Reverse(void)
{
    IN1 = 0; IN2 = 1;
    IN3 = 0; IN4 = 1;
}

void Motor_Turn_Left(void)
{
    /* Left motor reverse, right motor forward */
    IN1 = 0; IN2 = 1;
    IN3 = 1; IN4 = 0;
}

void Motor_Turn_Right(void)
{
    /* Left motor forward, right motor reverse */
    IN1 = 1; IN2 = 0;
    IN3 = 0; IN4 = 1;
}

void Motor_SetSpeed(u8 duty_cycle)
{
    /* Stub — ENA/ENB tied HIGH for now.
     * To add speed: connect ENA to CCP1 (RC2) and ENB to CCP2 (RC1)
     * and implement hardware PWM in MCAL/PWM. */
    (void)duty_cycle;
}
