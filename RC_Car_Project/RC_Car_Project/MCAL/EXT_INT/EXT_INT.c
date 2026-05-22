#include "EXT_INT_interface.h"
#include "EXT_INT_private.h"
#include "EXT_INT_config.h"
#include "../GPIO/GPIO_interface.h"
#include "../../SERVICES/BIT_MATH.h"
#include "../../SERVICES/config.h"
void EXT_INT_Init(void)
{
    /* Configure the external interrupt pin as input */
    GPIO_SetPinDirection(EXT_INT_PORT, EXT_INT_PIN, GPIO_INPUT);

    /* Configure the edge type for the external interrupt */
    EXT_INT_SetEdge(rising_edge); // Magnet AWAY (rising edge) triggers safety stop
    
    /* Clear the interrupt flag */
    CLR_BIT(INTCON, INTF_BIT);
    CLR_BIT(INTCON, INTE_BIT); // Ensure the external interrupt is disabled initially

}

void EXT_INT_Enable(void)
{
    /* Enable the external interrupt */
    SET_BIT(INTCON, INTE_BIT);
    
    /* Enable global interrupts */
    SET_BIT(INTCON, GIE_BIT);

    CLR_BIT(INTCON, INTF_BIT); // Clear any pending interrupt flag
}

void EXT_INT_Disable(void)
{
    /* Clear the interrupt flag */
    CLR_BIT(INTCON, INTF_BIT);
    /* Disable the external interrupt */
    CLR_BIT(INTCON, INTE_BIT);
    
}

void EXT_INT_SetEdge(u8 Edgetype)
{
    if (Edgetype == rising_edge)
    {
        /* Configure for rising edge */
        SET_BIT(OPTION_REG, INTEDGE_BIT); // INTEDG = 1 for rising edge
    }
    else if (Edgetype == falling_edge)
    {
        /* Configure for falling edge */
        CLR_BIT(OPTION_REG, INTEDGE_BIT); // INTEDG = 0 for falling edge
    }
}

