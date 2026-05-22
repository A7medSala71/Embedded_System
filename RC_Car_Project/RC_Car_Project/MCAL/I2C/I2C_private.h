#ifndef I2C_PRIVATE_H
#define I2C_PRIVATE_H

/* 
 * Standard bitfield names (GIE, PEIE, SSPIF, etc.) are already defined 
 * by the XC8 compiler in <xc.h>. Redefining them here causes collisions.
 * We rely on the compiler's definitions instead.
 */

/* ================= Registers Addresses (Fallback) ================= */
#ifndef SSPCON
#define SSPCON    (*(volatile unsigned char*)0x14)
#endif

#ifndef SSPCON2
#define SSPCON2   (*(volatile unsigned char*)0x91)
#endif

#ifndef SSPSTAT
#define SSPSTAT   (*(volatile unsigned char*)0x94)
#endif

#ifndef SSPBUF
#define SSPBUF    (*(volatile unsigned char*)0x13)
#endif

#ifndef SSPADD
#define SSPADD    (*(volatile unsigned char*)0x93)
#endif

#endif