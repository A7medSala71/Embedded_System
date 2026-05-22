#line 1 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/EXT_INT/EXT_INT.c"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/ext_int_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../../services/std_types.h"




typedef signed char s8;
typedef signed short int s16;
typedef signed long int s32;


typedef unsigned char u8;
typedef unsigned short int u16;
typedef unsigned long int u32;


typedef float f32;
typedef double f64;
typedef long double f128;
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../gpio/gpio_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../gpio/../../services/std_types.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../gpio/../../services/bit_math.h"
#line 31 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../gpio/gpio_interface.h"
void GPIO_SetPinDirection(u8 Port, u8 Pin, u8 Direction);
void GPIO_SetPinValue(u8 Port, u8 Pin, u8 Value);
u8 GPIO_GetPinValue(u8 Port, u8 Pin);
void GPIO_Init(void);
#line 18 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/ext_int_interface.h"
void EXT_INT_Init(void);
void EXT_INT_Enable(void);
void EXT_INT_Disable(void);
void EXT_INT_SetEdge(u8 Edgetype);
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/ext_int_private.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/ext_int_config.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../gpio/gpio_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/ext_int/../../services/bit_math.h"
#line 7 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/EXT_INT/EXT_INT.c"
void EXT_INT_Init(void)
{

 GPIO_SetPinDirection( 1 ,  0 ,  1 );


 EXT_INT_SetEdge( 0 );


  ( ( (*((volatile u8*)0x18B)) ) &= ~(1U << ( 1 )) ) ;
  ( ( (*((volatile u8*)0x18B)) ) &= ~(1U << ( 4 )) ) ;

}

void EXT_INT_Enable(void)
{

  ( ( (*((volatile u8*)0x18B)) ) |= (1U << ( 4 )) ) ;


  ( ( (*((volatile u8*)0x18B)) ) |= (1U << ( 7 )) ) ;

  ( ( (*((volatile u8*)0x18B)) ) &= ~(1U << ( 1 )) ) ;
}

void EXT_INT_Disable(void)
{

  ( ( (*((volatile u8*)0x18B)) ) &= ~(1U << ( 1 )) ) ;

  ( ( (*((volatile u8*)0x18B)) ) &= ~(1U << ( 4 )) ) ;

}

void EXT_INT_SetEdge(u8 Edgetype)
{
 if (Edgetype ==  1 )
 {

  ( ( (*((volatile u8*)0x181)) ) &= ~(1U << ( 6 )) ) ;
 }
 else if (Edgetype ==  0 )
 {

  ( ( (*((volatile u8*)0x181)) ) |= (1U << ( 6 )) ) ;
 }
}
