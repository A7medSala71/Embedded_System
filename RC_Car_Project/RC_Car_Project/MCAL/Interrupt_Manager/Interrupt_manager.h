#ifndef INTERRUPT_MANAGER_H
#define INTERRUPT_MANAGER_H

#include "../../SERVICES/STD_TYPES.h"

/* Register callback for INT0 (door magnetic switch) */
void EXT_INT_SetCallback(void (*ptr)(void));

#endif
