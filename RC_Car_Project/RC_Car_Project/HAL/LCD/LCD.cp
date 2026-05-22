#line 1 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/../../mcal/gpio/gpio_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/../../mcal/gpio/../../services/std_types.h"




typedef signed char s8;
typedef signed short int s16;
typedef signed long int s32;


typedef unsigned char u8;
typedef unsigned short int u16;
typedef unsigned long int u32;


typedef float f32;
typedef double f64;
typedef long double f128;
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/../../mcal/gpio/../../services/bit_math.h"
#line 31 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/../../mcal/gpio/gpio_interface.h"
void GPIO_SetPinDirection(u8 Port, u8 Pin, u8 Direction);
void GPIO_SetPinValue(u8 Port, u8 Pin, u8 Value);
u8 GPIO_GetPinValue(u8 Port, u8 Pin);
void GPIO_Init(void);
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/../../services/std_types.h"
#line 48 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_Init(void);
#line 53 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_Clear(void);
#line 60 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_SetCursor(u8 row, u8 col);
#line 66 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_WriteChar(u8 c);
#line 72 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_WriteString(char *str);
#line 79 "f:/fall 2026/dsp/es_course_labs/es_course_labs/hal/lcd/lcd.h"
void LCD_WriteNumber(u16 num);
#line 21 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
static void LCD_Pulse_EN(void) {
 GPIO_SetPinValue( 1 ,  3 ,  1 );
 Delay_us(2);
 GPIO_SetPinValue( 1 ,  3 ,  0 );
 Delay_us(50);
}
#line 33 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
static void LCD_Send_Nibble(u8 nibble) {
 u8 portd_val;


 portd_val = PORTD & 0xF0;


 portd_val |= (nibble & 0x0F);

 PORTD = portd_val;

 LCD_Pulse_EN();
}
#line 52 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
static void LCD_Send_Byte(u8 dat, u8 rs) {

 GPIO_SetPinValue( 1 ,  2 , rs);


 LCD_Send_Nibble((dat >> 4) & 0x0F);


 LCD_Send_Nibble(dat & 0x0F);


 if (dat ==  0x01  || dat ==  0x02 ) {
 Delay_ms(2);
 } else {
 Delay_us(50);
 }
}
#line 73 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
static void LCD_Send_Command(u8 cmd) { LCD_Send_Byte(cmd, 0); }
#line 78 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/HAL/LCD/LCD.c"
static void LCD_Send_Data(u8 dat) { LCD_Send_Byte(dat, 1); }



void LCD_Init(void) {

 GPIO_SetPinDirection( 1 ,  2 ,  0 );
 GPIO_SetPinDirection( 1 ,  3 ,  0 );


 GPIO_SetPinDirection( 3 ,  0 ,  0 );
 GPIO_SetPinDirection( 3 ,  1 ,  0 );
 GPIO_SetPinDirection( 3 ,  2 ,  0 );
 GPIO_SetPinDirection( 3 ,  3 ,  0 );


 GPIO_SetPinValue( 1 ,  2 ,  0 );
 GPIO_SetPinValue( 1 ,  3 ,  0 );


 Delay_ms(20);


 GPIO_SetPinValue( 1 ,  2 , 0);
 LCD_Send_Nibble(0x03);
 Delay_ms(5);

 LCD_Send_Nibble(0x03);
 Delay_us(150);

 LCD_Send_Nibble(0x03);
 Delay_us(150);


 LCD_Send_Nibble(0x02);
 Delay_us(150);


 LCD_Send_Command( 0x28 );


 LCD_Send_Command( 0x08 );


 LCD_Send_Command( 0x01 );


 LCD_Send_Command( 0x06 );


 LCD_Send_Command( 0x0C );
}

void LCD_Clear(void) { LCD_Send_Command( 0x01 ); }

void LCD_SetCursor(u8 row, u8 col) {
 u8 addr;

 if (row == 0) {
 addr =  0x00  + col;
 } else {
 addr =  0x40  + col;
 }

 LCD_Send_Command( 0x80  | addr);
}

void LCD_WriteChar(u8 c) { LCD_Send_Data(c); }

void LCD_WriteString(char *str) {
 while (*str) {
 LCD_Send_Data(*str);
 str++;
 }
}

void LCD_WriteNumber(u16 num) {
 u8 hundreds, tens, ones;
 u8 leading = 0;

 if (num > 999)
 num = 999;

 hundreds = 0;
 while (num >= 100) {
 hundreds++;
 num -= 100;
 }
 tens = 0;
 while (num >= 10) {
 tens++;
 num -= 10;
 }
 ones = (u8)num;

 if (hundreds > 0) {
 LCD_Send_Data('0' + hundreds);
 leading = 1;
 }
 if (tens > 0 || leading) {
 LCD_Send_Data('0' + tens);
 }
 LCD_Send_Data('0' + ones);
}
