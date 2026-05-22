#ifndef TMR1_INTERFACE_H
#define TMR1_INTERFACE_H
#include "../../SERVICES/STD_TYPES.h"
#include "../../SERVICES/BIT_MATH.h"
#include "TMR1_config.h"
#include "TMR1_private.h"
// Function prototypes for TMR1 interface functions
void TMR1_Init(void);
void TMR1_Start(void);
void TMR1_Stop(void);
void TMR1_SetPrescaler(u8 prescaler);
u16 TMR1_GetValue(void);
void TMR1_SetValue(u16 value);

#endif // TMR1_INTERFACE_H