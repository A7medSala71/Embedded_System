#include "SR04.h"
#include "../../SERVICES/config.h"
#include <xc.h>

#define SR04_TICKS_PER_CM   36U

static void TMR1_Start(void) {
    T1CONbits.TMR1ON = 0;   
    TMR1H = 0;
    TMR1L = 0;
    PIR1bits.TMR1IF = 0;    
    T1CON = 0b00110001;     
}

static u16 TMR1_Stop(void) {
    T1CONbits.TMR1ON = 0;
    return (u16)(((u16)TMR1H << 8) | TMR1L);
}

void SR04_Init(void) {
    ADCON1 = 0x07;          /* ALL pins digital */

    /* FRONT safely on PORTD (RD0, RD1) */
    TRISDbits.TRISD0 = 0;   PORTDbits.RD0 = 0; // TRIG
    TRISDbits.TRISD1 = 1;                      // ECHO

    /* LEFT on PORTB */
    TRISBbits.TRISB1 = 0;   PORTBbits.RB1 = 0; // TRIG
    TRISBbits.TRISB2 = 1;                      // ECHO

    /* RIGHT on PORTB */
    TRISBbits.TRISB3 = 0;   PORTBbits.RB3 = 0; // TRIG
    TRISBbits.TRISB4 = 1;                      // ECHO

    OPTION_REGbits.nRBPU = 1;
    T1CONbits.TMR1ON = 0;
}

u16 SR04_GetDistance(u8 sensor_id) {
    u16 timeout = 0;
    u16 ticks = 0;

    if (sensor_id == SR04_FRONT)      { PORTDbits.RD0 = 1; __delay_us(10); PORTDbits.RD0 = 0; }
    else if (sensor_id == SR04_LEFT)  { PORTBbits.RB1 = 1; __delay_us(10); PORTBbits.RB1 = 0; }
    else if (sensor_id == SR04_RIGHT) { PORTBbits.RB3 = 1; __delay_us(10); PORTBbits.RB3 = 0; }
    else return 999U;

    while(timeout < 500) {
        if (sensor_id == SR04_FRONT && PORTDbits.RD1) break;
        if (sensor_id == SR04_LEFT  && PORTBbits.RB2) break;
        if (sensor_id == SR04_RIGHT && PORTBbits.RB4) break;
        __delay_us(10);
        timeout++;
    }

    if (timeout >= 500) return 999U; 

    TMR1_Start();

    while(!PIR1bits.TMR1IF) {
        if (sensor_id == SR04_FRONT && !PORTDbits.RD1) break;
        if (sensor_id == SR04_LEFT  && !PORTBbits.RB2) break;
        if (sensor_id == SR04_RIGHT && !PORTBbits.RB4) break;
    }

    ticks = TMR1_Stop();

    if (PIR1bits.TMR1IF) {
        PIR1bits.TMR1IF = 0; 
        __delay_ms(40);      
        return 999U;
    }

    __delay_ms(40); 
    return (u16)(ticks / SR04_TICKS_PER_CM);
}