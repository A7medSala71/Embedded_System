#include <xc.h>
#include "UART_interface.h"
#include "../../SERVICES/config.h"

void UART_Init(u32 baud_rate)
{
    SPBRG = 129;

    TXSTAbits.BRGH = 1;
    TXSTAbits.SYNC = 0;
    TXSTAbits.TXEN = 1;

    TRISCbits.TRISC6 = 0;
    TRISCbits.TRISC7 = 1;

    RCSTAbits.SPEN = 1;
    RCSTAbits.CREN = 1;

    UART_ClearErrors();
    if (PIR1bits.RCIF) { volatile u8 dummy = RCREG; }
}

void UART_ClearErrors(void)
{
    if (RCSTAbits.OERR)
    {
        RCSTAbits.CREN = 0;
        RCSTAbits.CREN = 1;
    }
    if (RCSTAbits.FERR)
    {
        volatile u8 dummy = RCREG;
    }
}

void UART_SendChar(u8 data)
{
    while (!TXSTAbits.TRMT);
    TXREG = data;
}

void UART_SendString(const char *str)
{
    while (*str)
    {
        UART_SendChar((u8)*str);
        str++;
    }
}

void UART_SendUInt(u16 num)
{
    char buf[6];
    u8 i = 0;
    if (num == 0) { UART_SendChar('0'); return; }
    while (num > 0)
    {
        buf[i++] = (char)((num % 10) + '0');
        num /= 10;
    }
    while (i > 0) UART_SendChar((u8)buf[--i]);
}

u8 UART_DataAvailable(void)
{
    UART_ClearErrors();
    return PIR1bits.RCIF;
}

u8 UART_ReceiveChar(void)
{
    UART_ClearErrors();
    while (!PIR1bits.RCIF);
    return RCREG;
}

void UART_SendLog(u8 door_state, u8 belt_state,
                  u16 f_dist, u16 l_dist, u16 r_dist)
{
    UART_SendString("F:"); UART_SendUInt(f_dist);
    UART_SendString(" L:"); UART_SendUInt(l_dist);
    UART_SendString(" R:"); UART_SendUInt(r_dist);
    UART_SendString(" D:"); UART_SendChar(door_state ? '1' : '0');
    UART_SendString(" B:"); UART_SendChar(belt_state ? '1' : '0');
    UART_SendChar('\n');
}