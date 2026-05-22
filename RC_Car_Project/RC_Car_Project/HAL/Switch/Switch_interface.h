/**
 * @file Switch_interface.h
 * @brief Generic switch/button driver
 *
 * Usage in this project:
 *   Magnetic door switch  -> PORTA, PIN0 (active LOW when magnet present = door closed)
 *   Seatbelt push-button  -> PORTA, PIN1 (active LOW when pressed = seatbelt ON)
 *
 * Both switches should have external pull-up resistors (10k to Vcc).
 */

#ifndef SWITCH_INTERFACE_H
#define SWITCH_INTERFACE_H

#include "../../SERVICES/STD_TYPES.h"

void SWITCH_Init(u8 Port, u8 Pin);
u8   SWITCH_Read(u8 Port, u8 Pin);  /* returns 1 = HIGH, 0 = LOW     */

#endif
