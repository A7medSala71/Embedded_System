#ifndef EXT_INT_PRIVATE_H
#define EXT_INT_PRIVATE_H

#include "../SERVICES/STD_TYPES.h"
#ifndef INTCON
#define INTCON  (*((volatile u8*)0x18B))
#endif

#ifndef OPTION_REG
#define OPTION_REG (*((volatile u8*)0x181))
#endif

#endif