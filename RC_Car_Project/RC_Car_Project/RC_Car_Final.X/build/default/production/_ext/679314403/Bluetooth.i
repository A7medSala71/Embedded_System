# 1 "../HAL/Bluetooth/Bluetooth.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 295 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files\\Microchip\\xc8\\v3.10\\pic\\include/language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "../HAL/Bluetooth/Bluetooth.c" 2





# 1 "../HAL/Bluetooth/Bluetooth.h" 1
# 17 "../HAL/Bluetooth/Bluetooth.h"
# 1 "../HAL/Bluetooth/../../SERVICES/STD_TYPES.h" 1



typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;
typedef signed char s8;
typedef signed short s16;
# 18 "../HAL/Bluetooth/Bluetooth.h" 2
# 28 "../HAL/Bluetooth/Bluetooth.h"
void BT_Init(void);
void BT_SendLog(u8 door_closed,
                u8 belt_on,
                u16 dist_front,
                u16 dist_left,
                u16 dist_right,
                const char *state);
# 7 "../HAL/Bluetooth/Bluetooth.c" 2
# 1 "../HAL/Bluetooth/../../MCAL/UART/UART_interface.h" 1





void UART_Init(u32 baud_rate);
void UART_SendChar(u8 data);
void UART_SendString(const char *str);
void UART_SendUInt(u16 num);
u8 UART_ReceiveChar(void);
u8 UART_DataAvailable(void);
void UART_ClearErrors(void);
void UART_SendLog(u8 door_state, u8 belt_state,
                  u16 f_dist, u16 l_dist, u16 r_dist);
# 8 "../HAL/Bluetooth/Bluetooth.c" 2

void BT_Init(void)
{
    UART_Init(9600UL);
}


static void BT_Send3Digit(u16 val)
{

    if (val > 999U) val = 999U;
    UART_SendChar((u8)('0' + (val / 100U)));
    UART_SendChar((u8)('0' + ((val / 10U) % 10U)));
    UART_SendChar((u8)('0' + (val % 10U)));
}


void BT_SendLog(u8 door_closed,
                u8 belt_on,
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
