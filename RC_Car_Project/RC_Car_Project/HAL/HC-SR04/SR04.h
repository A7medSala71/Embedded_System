/**
 * @file SR04.h
 * @brief HC-SR04/SR05 Ultrasonic driver for 3-sensor setup
 *
 * PIN ASSIGNMENT:
 *
 *   Sensor    TRIG    ECHO
 *   FRONT     RC0     RC1
 *   LEFT      RB1     RB2   (moved from RD0/RD1 ? PSP interference)
 *   RIGHT     RB3     RB4   (moved from RD2/RD3 ? PSP interference)
 *
 * PORTD RD0-RD3 are now free. RD4-RD7 remain motor pins.
 */
#ifndef SR04_H
#define SR04_H
#include "../../SERVICES/STD_TYPES.h"

#define SR04_FRONT  0
#define SR04_LEFT   1
#define SR04_RIGHT  2

#define SR04_NO_OBJECT  400U    /* cm ? treat readings >= this as clear */

void SR04_Init(void);
u16  SR04_GetDistance(u8 sensor_id);
#endif