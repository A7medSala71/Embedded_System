#ifndef I2C_INTERFACE_H
#define I2C_INTERFACE_H
#include "I2C_private.h"
#include "I2C_config.h"
#include "../SERVICES/STD_TYPES.h"
#include "../../SERVICES/BIT_MATH.h"

void I2C_Master_Init(u32 baud_rate);
void I2C_Master_Wait(void);
void I2C_Master_Start(void);
void I2C_Master_RepeatedStart(void);
void I2C_Master_Stop(void);
void I2C_Master_Write(u8 data);
u8 I2C_Master_Read(u8 ack);

void I2C_Slave_Init(u8 node_address);

#endif