#include "I2C_Interface.h"
#include "../../SERVICES/config.h"

/**
 * @brief Initializes the PIC as an I2C Master
 * @param baud_rate Usually 100000 (100kHz) or 400000 (400kHz)
 */
void I2C_Master_Init(u32 baud_rate) {
    /* 1. Set RC3 (SCL) and RC4 (SDA) as Inputs */
    TRISCbits.TRISC3 = 1;
    TRISCbits.TRISC4 = 1;

    /* 2. Configure SSPSTAT Register */
    // SMP = 1: Disable Slew Rate Control (Standard 100kHz mode)
    // CKE = 0: Disable SMBus specific inputs
    SSPSTAT = 0x80;

    /* 3. Configure SSPCON Register */
    // SSPEN = 1: Enable Synchronous Serial Port
    // SSPM  = 1000: I2C Master mode, clock = FOSC / (4 * (SSPADD + 1))
    SSPCON = 0x28;

    /* 4. Load Baud Rate into SSPADD */
    // SSPADD = (FOSC / (4 * baud_rate)) - 1
    SSPADD = (u8)((_XTAL_FREQ / (4 * baud_rate)) - 1);
}

/**
 * @brief Waits until the I2C bus is idle
 */
void I2C_Master_Wait(void) {
    // Wait for Start, Repeated Start, Stop, Receive, or Acknowledge sequence to finish
    // And wait for Transmit in progress (SSPSTAT R/W bit)
    while ((SSPSTAT & 0x04) || (SSPCON2 & 0x1F));
}

void I2C_Master_Start(void) {
    I2C_Master_Wait();
    SSPCON2bits.SEN = 1; // Initiate Start condition
}

void I2C_Master_RepeatedStart(void) {
    I2C_Master_Wait();
    SSPCON2bits.RSEN = 1; // Initiate Repeated Start condition
}

void I2C_Master_Stop(void) {
    I2C_Master_Wait();
    SSPCON2bits.PEN = 1; // Initiate Stop condition
}

void I2C_Master_Write(u8 data) {
    I2C_Master_Wait();
    SSPBUF = data; // Load data into buffer
}

u8 I2C_Master_Read(u8 ack) {
    u8 temp;
    I2C_Master_Wait();
    SSPCON2bits.RCEN = 1; // Enable receive mode
    
    I2C_Master_Wait();
    temp = SSPBUF; // Read data
    
    I2C_Master_Wait();
    SSPCON2bits.ACKDT = (ack) ? 0 : 1; // 0 = ACK, 1 = NACK
    SSPCON2bits.ACKEN = 1; // Send acknowledge sequence
    
    return temp;
}

/**
 * @brief Initializes the PIC as an I2C Slave
 */
void I2C_Slave_Init(u8 node_address) {
    TRISCbits.TRISC3 = 1;
    TRISCbits.TRISC4 = 1;
    SSPADD = (u8)(node_address << 1);
    SSPSTAT = 0x80;
    SSPCON = 0x36;
    SSPCON2bits.SEN = 1;
    
    PIR1bits.SSPIF = 0;
    PIE1bits.SSPIE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
}