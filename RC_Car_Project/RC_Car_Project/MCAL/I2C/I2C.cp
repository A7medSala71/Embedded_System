#line 1 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/I2C/I2C.c"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/i2c_interface.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/i2c_private.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/i2c_config.h"
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/../../services/std_types.h"




typedef signed char s8;
typedef signed short int s16;
typedef signed long int s32;


typedef unsigned char u8;
typedef unsigned short int u16;
typedef unsigned long int u32;


typedef float f32;
typedef double f64;
typedef long double f128;
#line 1 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/../../services/bit_math.h"
#line 7 "f:/fall 2026/dsp/es_course_labs/es_course_labs/mcal/i2c/i2c_interface.h"
void I2C_Init(u32 feq);
void I2C_Master_Start(void);
void I2C_Master_Stop(void);
void I2C_Write_Byte(u8 wr_data);
u8 I2C_Read_Byte(void);
void I2C_Slave_Init(u8 node_address);

extern volatile u8 I2C_Rx_Data;
extern volatile u8 I2C_Data_Ready;
#line 4 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/I2C/I2C.c"
volatile u8 I2C_Rx_Data = 0;
volatile u8 I2C_Data_Ready = 0;
#line 11 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/I2C/I2C.c"
void I2C_Slave_Init(u8 node_address) {

  ( ( (*(volatile unsigned char*)0x87) ) |= (1U << ( 3 )) ) ;
  ( ( (*(volatile unsigned char*)0x87) ) |= (1U << ( 4 )) ) ;



  (*(volatile unsigned char*)0x93)  = node_address << 1;




  (*(volatile unsigned char*)0x94)  = 0x80;





  (*(volatile unsigned char*)0x14)  = 0x36;




  ( ( (*(volatile unsigned char*)0x91) ) |= (1U << ( 0 )) ) ;


  ( ( (*(volatile unsigned char*)0x0C) ) &= ~(1U << ( 3 )) ) ;
  ( ( (*(volatile unsigned char*)0x8C) ) |= (1U << ( 3 )) ) ;
  ( ( (*(volatile unsigned char*)0x0B) ) |= (1U << ( 6 )) ) ;
  ( ( (*(volatile unsigned char*)0x0B) ) |= (1U << ( 7 )) ) ;
}
#line 47 "F:/Fall 2026/DSP/ES_Course_Labs/ES_Course_Labs/MCAL/I2C/I2C.c"
void I2C_Init(u32 feq) {

}

void I2C_Master_Start(void) {
  ( ( (*(volatile unsigned char*)0x91) ) |= (1U << ( 0 )) ) ;
 while ( ( (( (*(volatile unsigned char*)0x91) ) >> ( 0 )) & 1U ) )
 ;
}
void I2C_Master_Stop(void) {
  ( ( (*(volatile unsigned char*)0x91) ) |= (1U << ( 2 )) ) ;
 while ( ( (( (*(volatile unsigned char*)0x91) ) >> ( 2 )) & 1U ) )
 ;
}

void I2C_Write_Byte(u8 wr_data) {
  (*(volatile unsigned char*)0x13)  = wr_data;
 while ( ( (( (*(volatile unsigned char*)0x94) ) >> ( 0 )) & 1U ) )
 ;
}

u8 I2C_Read_Byte(void) {
 while (! ( (( (*(volatile unsigned char*)0x94) ) >> ( 0 )) & 1U ) )
 ;
 return  (*(volatile unsigned char*)0x13) ;
}
