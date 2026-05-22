/**
 * @file Bluetooth.h
 * @brief HC-05 Bluetooth data logging HAL
 *
 * Wraps UART to send structured log packets to the laptop.
 *
 * Log format (ASCII, newline terminated):
 *   DOOR:<OPEN|CLOSED>,BELT:<ON|OFF>,FRONT:<cm>,LEFT:<cm>,RIGHT:<cm>,STATE:<state>\r\n
 *
 * Example:
 *   DOOR:CLOSED,BELT:ON,FRONT:045,LEFT:200,RIGHT:180,STATE:MOVING\r\n
 */

#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include "../../SERVICES/STD_TYPES.h"

/* System state codes */
#define BT_STATE_MOVING     "MOVING"
#define BT_STATE_STOPPED    "STOPPED"
#define BT_STATE_OBSTACLE   "OBSTACLE"
#define BT_STATE_TURNING_L  "TURN_L"
#define BT_STATE_TURNING_R  "TURN_R"
#define BT_STATE_NOSEATBELT "NO_BELT"
#define BT_STATE_DOOR_OPEN  "DOOR_OPEN"

void BT_Init(void);
void BT_SendLog(u8 door_closed,
                u8 belt_on,
                u16 dist_front,
                u16 dist_left,
                u16 dist_right,
                const char *state);

#endif
