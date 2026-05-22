
_I2C_Slave_Init:

;I2C.c,11 :: 		void I2C_Slave_Init(u8 node_address) {
;I2C.c,13 :: 		SET_BIT(TRISC, TRISC3);
	BSF        135, 3
;I2C.c,14 :: 		SET_BIT(TRISC, TRISC4);
	BSF        135, 4
;I2C.c,18 :: 		SSPADD = node_address << 1;
	MOVF       FARG_I2C_Slave_Init_node_address+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      147
;I2C.c,23 :: 		SSPSTAT = 0x80;
	MOVLW      128
	MOVWF      148
;I2C.c,29 :: 		SSPCON = 0x36;
	MOVLW      54
	MOVWF      20
;I2C.c,34 :: 		SET_BIT(SSPCON2, SEN);
	BSF        145, 0
;I2C.c,37 :: 		CLR_BIT(PIR1, SSPIF);  // Clear I2C interrupt flag
	MOVLW      247
	ANDWF      12, 1
;I2C.c,38 :: 		SET_BIT(PIE1, SSPIE);  // Enable I2C interrupts
	BSF        140, 3
;I2C.c,39 :: 		SET_BIT(INTCON, PEIE); // Enable Peripheral interrupts
	BSF        11, 6
;I2C.c,40 :: 		SET_BIT(INTCON, GIE);  // Enable Global interrupts
	BSF        11, 7
;I2C.c,41 :: 		}
L_end_I2C_Slave_Init:
	RETURN
; end of _I2C_Slave_Init

_I2C_Init:

;I2C.c,47 :: 		void I2C_Init(u32 feq) {
;I2C.c,49 :: 		}
L_end_I2C_Init:
	RETURN
; end of _I2C_Init

_I2C_Master_Start:

;I2C.c,51 :: 		void I2C_Master_Start(void) {
;I2C.c,52 :: 		SET_BIT(SSPCON2, SEN);
	BSF        145, 0
;I2C.c,53 :: 		while (GET_BIT(SSPCON2, SEN))
L_I2C_Master_Start0:
	MOVF       145, 0
	MOVWF      R1+0
	BTFSS      R1+0, 0
	GOTO       L_I2C_Master_Start1
;I2C.c,54 :: 		;
	GOTO       L_I2C_Master_Start0
L_I2C_Master_Start1:
;I2C.c,55 :: 		}
L_end_I2C_Master_Start:
	RETURN
; end of _I2C_Master_Start

_I2C_Master_Stop:

;I2C.c,56 :: 		void I2C_Master_Stop(void) {
;I2C.c,57 :: 		SET_BIT(SSPCON2, PEN);
	BSF        145, 2
;I2C.c,58 :: 		while (GET_BIT(SSPCON2, PEN))
L_I2C_Master_Stop2:
	MOVF       145, 0
	MOVWF      R1+0
	RRF        R1+0, 1
	BCF        R1+0, 7
	RRF        R1+0, 1
	BCF        R1+0, 7
	BTFSS      R1+0, 0
	GOTO       L_I2C_Master_Stop3
;I2C.c,59 :: 		;
	GOTO       L_I2C_Master_Stop2
L_I2C_Master_Stop3:
;I2C.c,60 :: 		}
L_end_I2C_Master_Stop:
	RETURN
; end of _I2C_Master_Stop

_I2C_Write_Byte:

;I2C.c,62 :: 		void I2C_Write_Byte(u8 wr_data) {
;I2C.c,63 :: 		SSPBUF = wr_data;
	MOVF       FARG_I2C_Write_Byte_wr_data+0, 0
	MOVWF      19
;I2C.c,64 :: 		while (GET_BIT(SSPSTAT, BF))
L_I2C_Write_Byte4:
	MOVF       148, 0
	MOVWF      R1+0
	BTFSS      R1+0, 0
	GOTO       L_I2C_Write_Byte5
;I2C.c,65 :: 		; // Wait until buffer is empty
	GOTO       L_I2C_Write_Byte4
L_I2C_Write_Byte5:
;I2C.c,66 :: 		}
L_end_I2C_Write_Byte:
	RETURN
; end of _I2C_Write_Byte

_I2C_Read_Byte:

;I2C.c,68 :: 		u8 I2C_Read_Byte(void) {
;I2C.c,69 :: 		while (!GET_BIT(SSPSTAT, BF))
L_I2C_Read_Byte6:
	MOVF       148, 0
	MOVWF      R1+0
	BTFSC      R1+0, 0
	GOTO       L_I2C_Read_Byte7
;I2C.c,70 :: 		; // Wait until buffer is full
	GOTO       L_I2C_Read_Byte6
L_I2C_Read_Byte7:
;I2C.c,71 :: 		return SSPBUF;
	MOVF       19, 0
	MOVWF      R0+0
;I2C.c,72 :: 		}
L_end_I2C_Read_Byte:
	RETURN
; end of _I2C_Read_Byte
