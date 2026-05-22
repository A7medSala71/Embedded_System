#include "LCD.h"
#include "../../MCAL/I2C/I2C_Interface.h"
#include "../../SERVICES/config.h"

/* Private state */
static u8 lcd_backlight = (1 << LCD_BL_BIT);

/* FLATTENING THE STACK: Macros instead of functions to save PIC16 stack levels */
#define PCF8574_Write(data) do { \
    I2C_Master_Start(); \
    I2C_Master_Write(LCD_I2C_ADDRESS << 1); \
    I2C_Master_Write(data); \
    I2C_Master_Stop(); \
} while(0)

#define LCD_Pulse_EN(byte_val) do { \
    PCF8574_Write((byte_val) | (1 << LCD_EN_BIT)); \
    __delay_us(2); \
    PCF8574_Write((byte_val) & ~(1 << LCD_EN_BIT)); \
    __delay_us(50); \
} while(0)

/**
 * @brief Sends a 4-bit nibble to the LCD (Now runs at a shallower stack depth)
 */
static void LCD_Send_Nibble(u8 nibble, u8 rs) {
    u8 byte_val = lcd_backlight;
    if (rs) byte_val |= (1 << LCD_RS_BIT);

    if (nibble & 0x01) byte_val |= (1 << LCD_D4_BIT);
    if (nibble & 0x02) byte_val |= (1 << LCD_D5_BIT);
    if (nibble & 0x04) byte_val |= (1 << LCD_D6_BIT);
    if (nibble & 0x08) byte_val |= (1 << LCD_D7_BIT);

    LCD_Pulse_EN(byte_val);
}

/**
 * @brief Sends a full byte in two 4-bit nibbles
 */
static void LCD_Send_Byte(u8 data, u8 rs) {
    LCD_Send_Nibble((data >> 4) & 0x0F, rs);
    LCD_Send_Nibble(data & 0x0F, rs);

    if (data == LCD_CMD_CLEAR || data == LCD_CMD_HOME) {
        __delay_ms(2);
    } else {
        __delay_us(50);
    }
}

void LCD_Init(void) {
    I2C_Master_Init(50000); /* Keep the safe 50kHz speed */
    __delay_ms(50);

    LCD_Send_Nibble(0x03, 0);
    __delay_ms(5);          
    LCD_Send_Nibble(0x03, 0);
    __delay_ms(5);          
    LCD_Send_Nibble(0x03, 0);
    __delay_us(200);        
    LCD_Send_Nibble(0x02, 0);
    __delay_us(200);

    LCD_Send_Byte(LCD_CMD_FUNCTION_SET, 0);
    LCD_Send_Byte(LCD_CMD_DISPLAY_OFF, 0);
    LCD_Send_Byte(LCD_CMD_CLEAR, 0);
    LCD_Send_Byte(LCD_CMD_ENTRY_MODE, 0);
    LCD_Send_Byte(LCD_CMD_DISPLAY_ON, 0);
}

void LCD_Clear(void) {
    LCD_Send_Byte(LCD_CMD_CLEAR, 0);
}

void LCD_SetCursor(u8 row, u8 col) {
    u8 addr = (row == 0) ? (LCD_ROW0_ADDR + col) : (LCD_ROW1_ADDR + col);
    LCD_Send_Byte(LCD_CMD_SET_DDRAM | addr, 0);
}

void LCD_WriteChar(u8 c) {
    LCD_Send_Byte(c, 1);
}

void LCD_WriteString(char *str) {
    while (*str) {
        LCD_Send_Byte((u8)*str, 1);
        str++;
    }
}

void LCD_WriteNumber(u16 num) {
    char buf[6];
    u8 i = 0;
    if (num == 0) {
        LCD_WriteChar('0');
        return;
    }
    while (num > 0) {
        buf[i++] = (num % 10) + '0';
        num /= 10;
    }
    while (i > 0) {
        LCD_WriteChar(buf[--i]);
    }
}

void LCD_SetBacklight(u8 state) {
    lcd_backlight = state ? (1 << LCD_BL_BIT) : 0;
    PCF8574_Write(lcd_backlight);
}