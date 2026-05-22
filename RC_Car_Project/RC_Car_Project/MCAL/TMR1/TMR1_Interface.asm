
_TMR1_Init:

;TMR1_Interface.c,3 :: 		void TMR1_Init(void) {
;TMR1_Interface.c,5 :: 		T1CON = 0x00; // Clear control register
	CLRF       16
;TMR1_Interface.c,6 :: 		CLR_BIT(T1CON, TMR1CS); // Use internal clock (Fosc/4)
	MOVLW      253
	ANDWF      16, 1
;TMR1_Interface.c,7 :: 		}
L_end_TMR1_Init:
	RETURN
; end of _TMR1_Init

_TMR1_Start:

;TMR1_Interface.c,9 :: 		void TMR1_Start(void) {
;TMR1_Interface.c,10 :: 		SET_BIT(T1CON, TMR1ON); // Start Timer1
	BSF        16, 0
;TMR1_Interface.c,11 :: 		SET_BIT(PIE1, TMR1IE); // Enable Timer1 interrupt
	BSF        140, 0
;TMR1_Interface.c,12 :: 		SET_BIT(INTCON, PEIE); // Enable peripheral interrupts
	BSF        11, 6
;TMR1_Interface.c,13 :: 		SET_BIT(INTCON, GIE);  // Enable global interrupts
	BSF        11, 7
;TMR1_Interface.c,14 :: 		}
L_end_TMR1_Start:
	RETURN
; end of _TMR1_Start

_TMR1_Stop:

;TMR1_Interface.c,16 :: 		void TMR1_Stop(void) {
;TMR1_Interface.c,17 :: 		CLR_BIT(T1CON, TMR1ON); // Stop Timer1
	MOVLW      254
	ANDWF      16, 1
;TMR1_Interface.c,18 :: 		}
L_end_TMR1_Stop:
	RETURN
; end of _TMR1_Stop

_TMR1_SetPrescaler:

;TMR1_Interface.c,20 :: 		void TMR1_SetPrescaler(u8 prescaler) {
;TMR1_Interface.c,22 :: 		T1CON &= ~(0xCF); // Clear bits 2 and 3
	MOVLW      48
	ANDWF      16, 1
;TMR1_Interface.c,25 :: 		switch (prescaler) {
	GOTO       L_TMR1_SetPrescaler0
;TMR1_Interface.c,26 :: 		case 1:
L_TMR1_SetPrescaler2:
;TMR1_Interface.c,28 :: 		break;
	GOTO       L_TMR1_SetPrescaler1
;TMR1_Interface.c,29 :: 		case 2:
L_TMR1_SetPrescaler3:
;TMR1_Interface.c,30 :: 		SET_BIT(T1CON, T1CKPS0); // Set bit 2 for 1:2
	BSF        16, 4
;TMR1_Interface.c,31 :: 		break;
	GOTO       L_TMR1_SetPrescaler1
;TMR1_Interface.c,32 :: 		case 4:
L_TMR1_SetPrescaler4:
;TMR1_Interface.c,33 :: 		SET_BIT(T1CON, T1CKPS1); // Set bit 3 for 1:4
	BSF        16, 5
;TMR1_Interface.c,34 :: 		break;
	GOTO       L_TMR1_SetPrescaler1
;TMR1_Interface.c,35 :: 		case 8:
L_TMR1_SetPrescaler5:
;TMR1_Interface.c,36 :: 		SET_BIT(T1CON, T1CKPS0); // Set bit 2
	BSF        16, 4
;TMR1_Interface.c,37 :: 		SET_BIT(T1CON, T1CKPS1); // Set bit 3 for 1:8
	BSF        16, 5
;TMR1_Interface.c,38 :: 		break;
	GOTO       L_TMR1_SetPrescaler1
;TMR1_Interface.c,39 :: 		default:
L_TMR1_SetPrescaler6:
;TMR1_Interface.c,41 :: 		break;
	GOTO       L_TMR1_SetPrescaler1
;TMR1_Interface.c,42 :: 		}
L_TMR1_SetPrescaler0:
	MOVF       FARG_TMR1_SetPrescaler_prescaler+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_TMR1_SetPrescaler2
	MOVF       FARG_TMR1_SetPrescaler_prescaler+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_TMR1_SetPrescaler3
	MOVF       FARG_TMR1_SetPrescaler_prescaler+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_TMR1_SetPrescaler4
	MOVF       FARG_TMR1_SetPrescaler_prescaler+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_TMR1_SetPrescaler5
	GOTO       L_TMR1_SetPrescaler6
L_TMR1_SetPrescaler1:
;TMR1_Interface.c,43 :: 		}
L_end_TMR1_SetPrescaler:
	RETURN
; end of _TMR1_SetPrescaler

_TMR1_SetValue:

;TMR1_Interface.c,45 :: 		void TMR1_SetValue(u16 value) {
;TMR1_Interface.c,46 :: 		TMR1H = (value >> 8) & 0xFF; // Set high byte
	CLRF       15
;TMR1_Interface.c,47 :: 		TMR1L = value & 0xFF;        // Set low byte
	MOVLW      255
	ANDWF      FARG_TMR1_SetValue_value+0, 0
	MOVWF      14
;TMR1_Interface.c,48 :: 		}
L_end_TMR1_SetValue:
	RETURN
; end of _TMR1_SetValue

_TMR1_GetValue:

;TMR1_Interface.c,50 :: 		u16 TMR1_GetValue(void) {
;TMR1_Interface.c,51 :: 		unsigned int value = 0;
;TMR1_Interface.c,52 :: 		value = (TMR1H << 8) | TMR1L; // Combine high and low bytes
	MOVF       15, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       14, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;TMR1_Interface.c,53 :: 		return value;
;TMR1_Interface.c,54 :: 		}
L_end_TMR1_GetValue:
	RETURN
; end of _TMR1_GetValue
