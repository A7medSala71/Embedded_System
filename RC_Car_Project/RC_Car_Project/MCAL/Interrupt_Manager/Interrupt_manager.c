/**
 * @file Interrupt_manager.c
 * @brief Central ISR for PIC16F877A
 *
 * Sources handled:
 *   - Timer1 overflow  -> Servo software PWM
 *   - INT0 (RB0)       -> Magnetic door switch (EXT_INT)
 *
 * All other peripheral interrupts (I2C, UART RX) are polled,
 * so they do not need ISR entries here.
 */

#include <xc.h>
#include "../../MCAL/PWM/PWM_interface.h"

/* Optional callback for INT0 (door switch) */
static void (*g_ext_int_callback)(void) = 0;

void EXT_INT_SetCallback(void (*ptr)(void))
{
    g_ext_int_callback = ptr;
}

void __interrupt() ISR(void)
{
    /* ---- INT0 (RB0): magnetic door switch ---- */
    if (INTCONbits.INTF && INTCONbits.INTE)
    {
        INTCONbits.INTF = 0;            /* must clear flag in ISR     */
        if (g_ext_int_callback)
            g_ext_int_callback();
    }
    
    /* Timer1 Interrupt is NO LONGER handled here. 
       We will poll Timer1 directly in the SR04 driver. */
}
