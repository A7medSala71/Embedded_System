/**
 * @file PWM_interface.c
 * @brief Software Servo PWM via Timer1 ISR
 *
 * PIC16F877A @ 20 MHz
 *   Fosc/4 = 5 MHz  -> instruction cycle = 0.2 us
 *   Timer1 prescaler 1:8  -> one Timer1 tick = 1.6 us
 *
 * Servo signal:
 *   Period  = 20 000 us  = 12 500 ticks
 *   0 deg   =  1 000 us  =    625 ticks
 *   90 deg  =  1 500 us  =    938 ticks
 *   180 deg =  2 000 us  =  1 250 ticks
 */

#include <xc.h>
#include "PWM_interface.h"
#include "../../SERVICES/config.h"

/* ---------- private state ---------------------------------------- */
#define PERIOD_TICKS  12500U   /* 20 ms in 1.6-us ticks              */

static volatile u16 g_pulse_ticks = 938U;   /* default 90 deg       */
static volatile u8  g_state       = 0U;     /* 0 = pulse HIGH phase  */
static volatile u8  g_suspended   = 0U;     /* 1 = ISR suspended     */

/* ------------------------------------------------------------------ */
void PWM_SetServoAngle(u8 angle)
{
    if (angle > 180U) angle = 180U;

    /* pulse_us = 1000 + angle*(1000/180)
     * ticks    = pulse_us / 1.6  = pulse_us * 10 / 16              */
    u32 pulse_us    = 1000UL + ((u32)angle * 1000UL) / 180UL;
    u16 new_ticks   = (u16)((pulse_us * 10UL) / 16UL);

    /* Atomic update (8-bit PIC: 16-bit write is not atomic)          */
    INTCONbits.GIE  = 0;
    g_pulse_ticks   = new_ticks;
    INTCONbits.GIE  = 1;
}

/* ------------------------------------------------------------------ */
void PWM_voidInitServo(void)
{
    TRISCbits.TRISC2 = 0;   /* RC2 = output                          */
    PORTCbits.RC2    = 0;

    /* Timer1: internal clock, prescaler 1:8, stopped                 */
    T1CON = 0x30;
    TMR1H = 0; TMR1L = 0;

    PIR1bits.TMR1IF  = 0;
    PIE1bits.TMR1IE  = 1;
    INTCONbits.PEIE  = 1;
    INTCONbits.GIE   = 1;

    T1CONbits.TMR1ON = 1;
}

/* ------------------------------------------------------------------ */
/**
 * @brief Pause servo ISR so SR04 can use Timer1 for echo timing.
 *        Motors are NOT stopped here — caller must stop them first.
 */
void PWM_voidDisableServoISR(void)
{
    g_suspended = 1U;
    PIE1bits.TMR1IE  = 0;      /* mask Timer1 interrupt              */
    T1CONbits.TMR1ON = 0;      /* stop timer                         */
    PORTCbits.RC2    = 0;      /* drive servo LOW (safe idle)        */
    PIR1bits.TMR1IF  = 0;      /* clear any stale flag               */
}

/* ------------------------------------------------------------------ */
/**
 * @brief Resume servo ISR after SR04 measurement is done.
 */
void PWM_voidEnableServoISR(void)
{
    if (!g_suspended) return;
    g_suspended      = 0U;
    g_state          = 0U;     /* restart at HIGH phase              */
    PIR1bits.TMR1IF  = 0;
    PIE1bits.TMR1IE  = 1;
    T1CONbits.TMR1ON = 1;
}

/* ------------------------------------------------------------------ */
void PWM_voidServoISR(void)
{
    PIR1bits.TMR1IF  = 0;
    T1CONbits.TMR1ON = 0;

    if (g_state == 0U)
    {
        PORTCbits.RC2 = 1;
        g_state = 1U;
        TMR1 = 65536U - g_pulse_ticks;
    }
    else
    {
        PORTCbits.RC2 = 0;
        g_state = 0U;
        u16 off_ticks = PERIOD_TICKS - g_pulse_ticks;
        TMR1 = 65536U - off_ticks;
    }

    T1CONbits.TMR1ON = 1;
}

/* ------------------------------------------------------------------ */
/* Motor speed: no hardware PWM channel assigned — stub only          */
void PWM_SetMotorSpeed(u8 duty)
{
    (void)duty;
    /* TODO: use CCP1/CCP2 hardware PWM if variable speed is needed   */
}
