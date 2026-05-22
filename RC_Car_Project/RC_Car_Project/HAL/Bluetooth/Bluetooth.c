/**
 * @file Bluetooth.c
 * @brief HC-05 Bluetooth data logging HAL (wraps UART)
 */

#include "Bluetooth.h"
#include "../../MCAL/UART/UART_interface.h"

void BT_Init(void)
{
    UART_Init(9600UL);  /* HC-05 factory default baud rate */
}

/* ------------------------------------------------------------------ */
static void BT_Send3Digit(u16 val)
{
    /* Always send 3 digits with leading zeros for fixed-width logging */
    if (val > 999U) val = 999U;
    UART_SendChar((u8)('0' + (val / 100U)));
    UART_SendChar((u8)('0' + ((val / 10U) % 10U)));
    UART_SendChar((u8)('0' + (val % 10U)));
}

/* ------------------------------------------------------------------ */
void BT_SendLog(u8  door_closed,
                u8  belt_on,
                u16 dist_front,
                u16 dist_left,
                u16 dist_right,
                const char *state)
{
    UART_SendString("DOOR:");
    UART_SendString(door_closed ? "CLOSED" : "OPEN");

    UART_SendString(",BELT:");
    UART_SendString(belt_on ? "ON" : "OFF");

    UART_SendString(",FRONT:");
    BT_Send3Digit(dist_front);

    UART_SendString(",LEFT:");
    BT_Send3Digit(dist_left);

    UART_SendString(",RIGHT:");
    BT_Send3Digit(dist_right);

    UART_SendString(",STATE:");
    UART_SendString(state);

    UART_SendString("\r\n");
}
