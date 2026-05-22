#include "TMR1_Interface.h"
#include "../../SERVICES/config.h"
#include "../../SERVICES/STD_TYPES.h"

/* NOTE: TMR1_SetCallback is defined in Interrupt_manager.c ? not here */

void TMR1_Init(void)
{
    T1CON  = 0x00;
    TMR1H  = 0;
    TMR1L  = 0;
    CLR_BIT(T1CON,  TMR1_TMR1CS);      /* internal clock (Fosc/4)  */
    CLR_BIT(PIE1,   TMR1_TMR1IE);      /* interrupt OFF at start   */
    CLR_BIT(PIR1,   TMR1IF);           /* clear any stale flag     */
}

void TMR1_SetPrescaler(u8 prescaler)
{
    T1CON &= 0xCF;
    switch (prescaler)
    {
        case 2:  SET_BIT(T1CON, TMR1_T1CKPS0); break;
        case 4:  SET_BIT(T1CON, TMR1_T1CKPS1); break;
        case 8:  SET_BIT(T1CON, TMR1_T1CKPS0);
                 SET_BIT(T1CON, TMR1_T1CKPS1); break;
        default: break;
    }
}

void TMR1_SetValue(u16 value)
{
    TMR1H = (u8)((value >> 8) & 0xFF);
    TMR1L = (u8)(value & 0xFF);
}

u16 TMR1_GetValue(void)
{
    return (u16)(((u16)TMR1H << 8) | TMR1L);
}

void TMR1_Start(void)
{
    CLR_BIT(PIR1,   TMR1IF);           /* clear stale overflow flag */
    SET_BIT(PIE1,   TMR1_TMR1IE);      /* enable Timer1 interrupt  */
    SET_BIT(INTCON, TMR1_PEIE);        /* peripheral interrupts ON */
    SET_BIT(INTCON, TMR1_GIE);         /* global interrupts ON     */
    SET_BIT(T1CON,  TMR1_TMR1ON);      /* START timer last         */
}

void TMR1_Stop(void)
{
    CLR_BIT(T1CON, TMR1_TMR1ON);       /* stop timer               */
    CLR_BIT(PIE1,  TMR1_TMR1IE);       /* disable Timer1 interrupt */
    CLR_BIT(PIR1,  TMR1IF);            /* clear flag               */
}