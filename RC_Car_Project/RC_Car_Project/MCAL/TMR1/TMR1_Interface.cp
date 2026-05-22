#line 1 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/TMR1/TMR1_Interface.c"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/tmr1_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/../../services/std_types.h"




typedef signed char s8;
typedef signed short int s16;
typedef signed long int s32;


typedef unsigned char u8;
typedef unsigned short int u16;
typedef unsigned long int u32;


typedef float f32;
typedef double f64;
typedef long double f128;
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/../../services/bit_math.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/tmr1_config.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/tmr1_private.h"
#line 8 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/tmr1/tmr1_interface.h"
void TMR1_Init(void);
void TMR1_Start(void);
void TMR1_Stop(void);
void TMR1_SetPrescaler(u8 prescaler);
u16 TMR1_GetValue(void);
void TMR1_SetValue(u16 value);
#line 3 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/TMR1/TMR1_Interface.c"
void TMR1_Init(void) {

  (*(volatile unsigned char*)0x10)  = 0x00;
  ( ( (*(volatile unsigned char*)0x10) ) &= ~(1U << ( 1 )) ) ;
}

void TMR1_Start(void) {
  ( ( (*(volatile unsigned char*)0x10) ) |= (1U << ( 0 )) ) ;
  ( ( (*(volatile unsigned char*)0x8C) ) |= (1U << ( 0 )) ) ;
  ( ( (*(volatile unsigned char*)0x0B) ) |= (1U << ( 6 )) ) ;
  ( ( (*(volatile unsigned char*)0x0B) ) |= (1U << ( 7 )) ) ;
}

void TMR1_Stop(void) {
  ( ( (*(volatile unsigned char*)0x10) ) &= ~(1U << ( 0 )) ) ;
}

void TMR1_SetPrescaler(u8 prescaler) {

  (*(volatile unsigned char*)0x10)  &= ~(0xCF);


 switch (prescaler) {
 case 1:

 break;
 case 2:
  ( ( (*(volatile unsigned char*)0x10) ) |= (1U << ( 4 )) ) ;
 break;
 case 4:
  ( ( (*(volatile unsigned char*)0x10) ) |= (1U << ( 5 )) ) ;
 break;
 case 8:
  ( ( (*(volatile unsigned char*)0x10) ) |= (1U << ( 4 )) ) ;
  ( ( (*(volatile unsigned char*)0x10) ) |= (1U << ( 5 )) ) ;
 break;
 default:

 break;
 }
}

void TMR1_SetValue(u16 value) {
  (*(volatile unsigned char*)0x0F)  = (value >> 8) & 0xFF;
  (*(volatile unsigned char*)0x0E)  = value & 0xFF;
}

u16 TMR1_GetValue(void) {
 unsigned int value = 0;
 value = ( (*(volatile unsigned char*)0x0F)  << 8) |  (*(volatile unsigned char*)0x0E) ;
 return value;
}
