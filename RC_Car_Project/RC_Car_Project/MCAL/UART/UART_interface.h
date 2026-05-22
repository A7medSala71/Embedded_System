#ifndef UART_INTERFACE_H
#define UART_INTERFACE_H

#include "../../SERVICES/STD_TYPES.h"

void UART_Init(u32 baud_rate);
void UART_SendChar(u8 data);
void UART_SendString(const char *str);
void UART_SendUInt(u16 num);
u8   UART_ReceiveChar(void);
u8   UART_DataAvailable(void);
void UART_ClearErrors(void);
void UART_SendLog(u8 door_state, u8 belt_state,
                  u16 f_dist, u16 l_dist, u16 r_dist);

#endif