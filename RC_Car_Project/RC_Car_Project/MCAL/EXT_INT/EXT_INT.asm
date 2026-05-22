
_EXT_INT_Init:

;EXT_INT.c,7 :: 		void EXT_INT_Init(void)
;EXT_INT.c,10 :: 		GPIO_SetPinDirection(EXT_INT_PORT, EXT_INT_PIN, GPIO_INPUT);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	CLRF       FARG_GPIO_SetPinDirection_Pin+0
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;EXT_INT.c,13 :: 		EXT_INT_SetEdge(falling_edge); // Default to falling edge, can be changed later
	CLRF       FARG_EXT_INT_SetEdge_Edgetype+0
	CALL       _EXT_INT_SetEdge+0
;EXT_INT.c,16 :: 		CLR_BIT(INTCON, INTF_BIT);
	MOVLW      253
	ANDWF      395, 1
;EXT_INT.c,17 :: 		CLR_BIT(INTCON, INTE_BIT); // Ensure the external interrupt is disabled initially
	MOVLW      239
	ANDWF      395, 1
;EXT_INT.c,19 :: 		}
L_end_EXT_INT_Init:
	RETURN
; end of _EXT_INT_Init

_EXT_INT_Enable:

;EXT_INT.c,21 :: 		void EXT_INT_Enable(void)
;EXT_INT.c,24 :: 		SET_BIT(INTCON, INTE_BIT);
	BSF        395, 4
;EXT_INT.c,27 :: 		SET_BIT(INTCON, GIE_BIT);
	BSF        395, 7
;EXT_INT.c,29 :: 		CLR_BIT(INTCON, INTF_BIT); // Clear any pending interrupt flag
	MOVLW      253
	ANDWF      395, 1
;EXT_INT.c,30 :: 		}
L_end_EXT_INT_Enable:
	RETURN
; end of _EXT_INT_Enable

_EXT_INT_Disable:

;EXT_INT.c,32 :: 		void EXT_INT_Disable(void)
;EXT_INT.c,35 :: 		CLR_BIT(INTCON, INTF_BIT);
	MOVLW      253
	ANDWF      395, 1
;EXT_INT.c,37 :: 		CLR_BIT(INTCON, INTE_BIT);
	MOVLW      239
	ANDWF      395, 1
;EXT_INT.c,39 :: 		}
L_end_EXT_INT_Disable:
	RETURN
; end of _EXT_INT_Disable

_EXT_INT_SetEdge:

;EXT_INT.c,41 :: 		void EXT_INT_SetEdge(u8 Edgetype)
;EXT_INT.c,43 :: 		if (Edgetype == rising_edge)
	MOVF       FARG_EXT_INT_SetEdge_Edgetype+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_EXT_INT_SetEdge0
;EXT_INT.c,46 :: 		CLR_BIT(OPTION_REG, INTEDGE_BIT); // INTEDG0 = 0 for rising edge
	MOVLW      191
	ANDWF      385, 1
;EXT_INT.c,47 :: 		}
	GOTO       L_EXT_INT_SetEdge1
L_EXT_INT_SetEdge0:
;EXT_INT.c,48 :: 		else if (Edgetype == falling_edge)
	MOVF       FARG_EXT_INT_SetEdge_Edgetype+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_EXT_INT_SetEdge2
;EXT_INT.c,51 :: 		SET_BIT(OPTION_REG, INTEDGE_BIT); // INTEDG0 = 1 for falling edge
	BSF        385, 6
;EXT_INT.c,52 :: 		}
L_EXT_INT_SetEdge2:
L_EXT_INT_SetEdge1:
;EXT_INT.c,53 :: 		}
L_end_EXT_INT_SetEdge:
	RETURN
; end of _EXT_INT_SetEdge
