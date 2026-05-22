#include "Switch_interface.h"
#include "../../MCAL/GPIO/GPIO_interface.h"

void SWITCH_Init(u8 Port, u8 Pin)
{
    GPIO_SetPinDirection(Port, Pin, GPIO_INPUT);
}

u8 SWITCH_Read(u8 Port, u8 Pin)
{
    return GPIO_GetPinValue(Port, Pin);
}
