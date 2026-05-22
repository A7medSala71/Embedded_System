#ifndef TMR1_PRIVATE_H
#define TMR1_PRIVATE_H

#include "../../SERVICES/STD_TYPES.h"

/* 
 * Standard bitfield names (TMR1IF, TMR1IE, etc.) are already defined 
 * by the XC8 compiler in <xc.h>. Redefining them here causes collisions
 * with the bitfield structures (e.g., PIR1bits.TMR1IF).
 * 
 * We use prefixed names for our bit positions to avoid these conflicts.
 */

/* ================= Registers Addresses ================= */
#ifndef TMR1L
#define TMR1L    (*(volatile unsigned char*)0x0E)
#endif
#ifndef TMR1H
#define TMR1H    (*(volatile unsigned char*)0x0F)
#endif
#ifndef T1CON
#define T1CON    (*(volatile unsigned char*)0x10)
#endif

/* ================= T1CON Bits ================= */
#define TMR1_TMR1ON   0
#define TMR1_TMR1CS   1
#define TMR1_T1SYNC   2   
#define TMR1_T1OSCEN  3   
#define TMR1_T1CKPS0  4   
#define TMR1_T1CKPS1  5   

#ifndef PIE1
#define PIE1    (*(volatile unsigned char*)0x8C)
#endif
#ifndef PIR1
#define PIR1    (*(volatile unsigned char*)0x0C)
#endif
#ifndef INTCON
#define INTCON   (*(volatile unsigned char*)0x0B)
#endif

#define TMR1_PEIE     6
#define TMR1_GIE      7
#define TMR1_TMR1IE   0
#define TMR1_TMR1IF   0

#endif