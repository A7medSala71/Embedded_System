/**
 * @file LCD.h
 * @author Ahmed Salah
 * @date 2026-04-23
 * @brief LCD 16x2 Driver via I2C PCF8574 Backpack
 */

#ifndef LCD_H
#define LCD_H

#include "../../SERVICES/STD_TYPES.h"
/* ================= I2C Configuration ================= */
#define LCD_I2C_ADDRESS    0x27    /* Default PCF8574 address (use 0x3F for PCF8574A) */

/* ================= LCD Commands ================= */
#define LCD_CMD_CLEAR          0x01
#define LCD_CMD_HOME           0x02
#define LCD_CMD_ENTRY_MODE     0x06 /* Increment cursor, no shift */
#define LCD_CMD_DISPLAY_ON     0x0C /* Display ON, Cursor OFF, Blink OFF */
#define LCD_CMD_DISPLAY_OFF    0x08
#define LCD_CMD_FUNCTION_SET   0x28 /* 4-bit, 2-line, 5x8 font */
#define LCD_CMD_SET_DDRAM      0x80 /* Set DDRAM address */

/* Row base addresses */
#define LCD_ROW0_ADDR 0x00
#define LCD_ROW1_ADDR 0x40

/* PCF8574 Pin Mapping */
#define LCD_RS_BIT    0
#define LCD_RW_BIT    1
#define LCD_EN_BIT    2
#define LCD_BL_BIT    3
#define LCD_D4_BIT    4
#define LCD_D5_BIT    5
#define LCD_D6_BIT    6
#define LCD_D7_BIT    7

/* ================= API ================= */
void LCD_Init(void);
void LCD_Clear(void);
void LCD_SetCursor(u8 row, u8 col);
void LCD_WriteChar(u8 c);
void LCD_WriteString(char *str);
void LCD_WriteNumber(u16 num);
void LCD_SetBacklight(u8 state);

#endif
