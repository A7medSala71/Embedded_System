
LCD_LCD_Pulse_EN:

;LCD.c,21 :: 		static void LCD_Pulse_EN(void) {
;LCD.c,22 :: 		GPIO_SetPinValue(LCD_EN_PORT, LCD_EN_PIN, GPIO_HIGH);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,23 :: 		Delay_us(2);
	MOVLW      2
	MOVWF      R13+0
L_LCD_LCD_Pulse_EN0:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_LCD_Pulse_EN0
	NOP
;LCD.c,24 :: 		GPIO_SetPinValue(LCD_EN_PORT, LCD_EN_PIN, GPIO_LOW);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	CLRF       FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,25 :: 		Delay_us(50);
	MOVLW      66
	MOVWF      R13+0
L_LCD_LCD_Pulse_EN1:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_LCD_Pulse_EN1
	NOP
;LCD.c,26 :: 		}
L_end_LCD_Pulse_EN:
	RETURN
; end of LCD_LCD_Pulse_EN

LCD_LCD_Send_Nibble:

;LCD.c,33 :: 		static void LCD_Send_Nibble(u8 nibble) {
;LCD.c,37 :: 		portd_val = PORTD & 0xF0;
	MOVLW      240
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
;LCD.c,40 :: 		portd_val |= (nibble & 0x0F);
	MOVLW      15
	ANDWF      FARG_LCD_LCD_Send_Nibble_nibble+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 0
	MOVWF      PORTD+0
;LCD.c,42 :: 		PORTD = portd_val;
;LCD.c,44 :: 		LCD_Pulse_EN();
	CALL       LCD_LCD_Pulse_EN+0
;LCD.c,45 :: 		}
L_end_LCD_Send_Nibble:
	RETURN
; end of LCD_LCD_Send_Nibble

LCD_LCD_Send_Byte:

;LCD.c,52 :: 		static void LCD_Send_Byte(u8 dat, u8 rs) {
;LCD.c,54 :: 		GPIO_SetPinValue(LCD_RS_PORT, LCD_RS_PIN, rs);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      2
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	MOVF       FARG_LCD_LCD_Send_Byte_rs+0, 0
	MOVWF      FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,57 :: 		LCD_Send_Nibble((dat >> 4) & 0x0F);
	MOVF       FARG_LCD_LCD_Send_Byte_dat+0, 0
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	RRF        FARG_LCD_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_LCD_LCD_Send_Nibble_nibble+0, 7
	RRF        FARG_LCD_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_LCD_LCD_Send_Nibble_nibble+0, 7
	RRF        FARG_LCD_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_LCD_LCD_Send_Nibble_nibble+0, 7
	RRF        FARG_LCD_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_LCD_LCD_Send_Nibble_nibble+0, 7
	MOVLW      15
	ANDWF      FARG_LCD_LCD_Send_Nibble_nibble+0, 1
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,60 :: 		LCD_Send_Nibble(dat & 0x0F);
	MOVLW      15
	ANDWF      FARG_LCD_LCD_Send_Byte_dat+0, 0
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,63 :: 		if (dat == LCD_CMD_CLEAR || dat == LCD_CMD_HOME) {
	MOVF       FARG_LCD_LCD_Send_Byte_dat+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_LCD_Send_Byte26
	MOVF       FARG_LCD_LCD_Send_Byte_dat+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_LCD_Send_Byte26
	GOTO       L_LCD_LCD_Send_Byte4
L_LCD_LCD_Send_Byte26:
;LCD.c,64 :: 		Delay_ms(2); /* Clear and Home need ~1.64ms */
	MOVLW      11
	MOVWF      R12+0
	MOVLW      98
	MOVWF      R13+0
L_LCD_LCD_Send_Byte5:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_LCD_Send_Byte5
	DECFSZ     R12+0, 1
	GOTO       L_LCD_LCD_Send_Byte5
	NOP
;LCD.c,65 :: 		} else {
	GOTO       L_LCD_LCD_Send_Byte6
L_LCD_LCD_Send_Byte4:
;LCD.c,66 :: 		Delay_us(50);
	MOVLW      66
	MOVWF      R13+0
L_LCD_LCD_Send_Byte7:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_LCD_Send_Byte7
	NOP
;LCD.c,67 :: 		}
L_LCD_LCD_Send_Byte6:
;LCD.c,68 :: 		}
L_end_LCD_Send_Byte:
	RETURN
; end of LCD_LCD_Send_Byte

LCD_LCD_Send_Command:

;LCD.c,73 :: 		static void LCD_Send_Command(u8 cmd) { LCD_Send_Byte(cmd, 0); }
	MOVF       FARG_LCD_LCD_Send_Command_cmd+0, 0
	MOVWF      FARG_LCD_LCD_Send_Byte_dat+0
	CLRF       FARG_LCD_LCD_Send_Byte_rs+0
	CALL       LCD_LCD_Send_Byte+0
L_end_LCD_Send_Command:
	RETURN
; end of LCD_LCD_Send_Command

LCD_LCD_Send_Data:

;LCD.c,78 :: 		static void LCD_Send_Data(u8 dat) { LCD_Send_Byte(dat, 1); }
	MOVF       FARG_LCD_LCD_Send_Data_dat+0, 0
	MOVWF      FARG_LCD_LCD_Send_Byte_dat+0
	MOVLW      1
	MOVWF      FARG_LCD_LCD_Send_Byte_rs+0
	CALL       LCD_LCD_Send_Byte+0
L_end_LCD_Send_Data:
	RETURN
; end of LCD_LCD_Send_Data

_LCD_Init:

;LCD.c,82 :: 		void LCD_Init(void) {
;LCD.c,84 :: 		GPIO_SetPinDirection(LCD_RS_PORT, LCD_RS_PIN, GPIO_OUTPUT);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	MOVLW      2
	MOVWF      FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,85 :: 		GPIO_SetPinDirection(LCD_EN_PORT, LCD_EN_PIN, GPIO_OUTPUT);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,88 :: 		GPIO_SetPinDirection(LCD_DATA_PORT, GPIO_PIN0, GPIO_OUTPUT);
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	CLRF       FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,89 :: 		GPIO_SetPinDirection(LCD_DATA_PORT, GPIO_PIN1, GPIO_OUTPUT);
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,90 :: 		GPIO_SetPinDirection(LCD_DATA_PORT, GPIO_PIN2, GPIO_OUTPUT);
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	MOVLW      2
	MOVWF      FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,91 :: 		GPIO_SetPinDirection(LCD_DATA_PORT, GPIO_PIN3, GPIO_OUTPUT);
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Port+0
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinDirection_Pin+0
	CLRF       FARG_GPIO_SetPinDirection_Direction+0
	CALL       _GPIO_SetPinDirection+0
;LCD.c,94 :: 		GPIO_SetPinValue(LCD_RS_PORT, LCD_RS_PIN, GPIO_LOW);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      2
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	CLRF       FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,95 :: 		GPIO_SetPinValue(LCD_EN_PORT, LCD_EN_PIN, GPIO_LOW);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      3
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	CLRF       FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,98 :: 		Delay_ms(20); /* Wait >15ms after VCC rises to 4.5V */
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_LCD_Init8:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Init8
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Init8
	NOP
;LCD.c,101 :: 		GPIO_SetPinValue(LCD_RS_PORT, LCD_RS_PIN, 0);
	MOVLW      1
	MOVWF      FARG_GPIO_SetPinValue_Port+0
	MOVLW      2
	MOVWF      FARG_GPIO_SetPinValue_Pin+0
	CLRF       FARG_GPIO_SetPinValue_Value+0
	CALL       _GPIO_SetPinValue+0
;LCD.c,102 :: 		LCD_Send_Nibble(0x03);
	MOVLW      3
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,103 :: 		Delay_ms(5); /* Wait >4.1ms */
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_LCD_Init9:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Init9
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Init9
	NOP
;LCD.c,105 :: 		LCD_Send_Nibble(0x03);
	MOVLW      3
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,106 :: 		Delay_us(150); /* Wait >100us */
	MOVLW      199
	MOVWF      R13+0
L_LCD_Init10:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Init10
	NOP
	NOP
;LCD.c,108 :: 		LCD_Send_Nibble(0x03);
	MOVLW      3
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,109 :: 		Delay_us(150);
	MOVLW      199
	MOVWF      R13+0
L_LCD_Init11:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Init11
	NOP
	NOP
;LCD.c,112 :: 		LCD_Send_Nibble(0x02);
	MOVLW      2
	MOVWF      FARG_LCD_LCD_Send_Nibble_nibble+0
	CALL       LCD_LCD_Send_Nibble+0
;LCD.c,113 :: 		Delay_us(150);
	MOVLW      199
	MOVWF      R13+0
L_LCD_Init12:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Init12
	NOP
	NOP
;LCD.c,116 :: 		LCD_Send_Command(LCD_CMD_FUNCTION_SET);
	MOVLW      40
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,119 :: 		LCD_Send_Command(LCD_CMD_DISPLAY_OFF);
	MOVLW      8
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,122 :: 		LCD_Send_Command(LCD_CMD_CLEAR);
	MOVLW      1
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,125 :: 		LCD_Send_Command(LCD_CMD_ENTRY_MODE);
	MOVLW      6
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,128 :: 		LCD_Send_Command(LCD_CMD_DISPLAY_ON);
	MOVLW      12
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,129 :: 		}
L_end_LCD_Init:
	RETURN
; end of _LCD_Init

_LCD_Clear:

;LCD.c,131 :: 		void LCD_Clear(void) { LCD_Send_Command(LCD_CMD_CLEAR); }
	MOVLW      1
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
L_end_LCD_Clear:
	RETURN
; end of _LCD_Clear

_LCD_SetCursor:

;LCD.c,133 :: 		void LCD_SetCursor(u8 row, u8 col) {
;LCD.c,136 :: 		if (row == 0) {
	MOVF       FARG_LCD_SetCursor_row+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_LCD_SetCursor13
;LCD.c,137 :: 		addr = LCD_ROW0_ADDR + col;
	MOVF       FARG_LCD_SetCursor_col+0, 0
	MOVWF      LCD_SetCursor_addr_L0+0
;LCD.c,138 :: 		} else {
	GOTO       L_LCD_SetCursor14
L_LCD_SetCursor13:
;LCD.c,139 :: 		addr = LCD_ROW1_ADDR + col;
	MOVF       FARG_LCD_SetCursor_col+0, 0
	ADDLW      64
	MOVWF      LCD_SetCursor_addr_L0+0
;LCD.c,140 :: 		}
L_LCD_SetCursor14:
;LCD.c,142 :: 		LCD_Send_Command(LCD_CMD_SET_DDRAM | addr);
	MOVLW      128
	IORWF      LCD_SetCursor_addr_L0+0, 0
	MOVWF      FARG_LCD_LCD_Send_Command_cmd+0
	CALL       LCD_LCD_Send_Command+0
;LCD.c,143 :: 		}
L_end_LCD_SetCursor:
	RETURN
; end of _LCD_SetCursor

_LCD_WriteChar:

;LCD.c,145 :: 		void LCD_WriteChar(u8 c) { LCD_Send_Data(c); }
	MOVF       FARG_LCD_WriteChar_c+0, 0
	MOVWF      FARG_LCD_LCD_Send_Data_dat+0
	CALL       LCD_LCD_Send_Data+0
L_end_LCD_WriteChar:
	RETURN
; end of _LCD_WriteChar

_LCD_WriteString:

;LCD.c,147 :: 		void LCD_WriteString(char *str) {
;LCD.c,148 :: 		while (*str) {
L_LCD_WriteString15:
	MOVF       FARG_LCD_WriteString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_WriteString16
;LCD.c,149 :: 		LCD_Send_Data(*str);
	MOVF       FARG_LCD_WriteString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_LCD_LCD_Send_Data_dat+0
	CALL       LCD_LCD_Send_Data+0
;LCD.c,150 :: 		str++;
	INCF       FARG_LCD_WriteString_str+0, 1
;LCD.c,151 :: 		}
	GOTO       L_LCD_WriteString15
L_LCD_WriteString16:
;LCD.c,152 :: 		}
L_end_LCD_WriteString:
	RETURN
; end of _LCD_WriteString

_LCD_WriteNumber:

;LCD.c,154 :: 		void LCD_WriteNumber(u16 num) {
;LCD.c,156 :: 		u8 leading = 0;
	CLRF       LCD_WriteNumber_leading_L0+0
;LCD.c,158 :: 		if (num > 999)
	MOVLW      128
	XORLW      3
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__LCD_WriteNumber39
	MOVF       FARG_LCD_WriteNumber_num+0, 0
	SUBLW      231
L__LCD_WriteNumber39:
	BTFSC      STATUS+0, 0
	GOTO       L_LCD_WriteNumber17
;LCD.c,159 :: 		num = 999;
	MOVLW      231
	MOVWF      FARG_LCD_WriteNumber_num+0
L_LCD_WriteNumber17:
;LCD.c,161 :: 		hundreds = 0;
	CLRF       LCD_WriteNumber_hundreds_L0+0
;LCD.c,162 :: 		while (num >= 100) {
L_LCD_WriteNumber18:
	MOVLW      100
	SUBWF      FARG_LCD_WriteNumber_num+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_LCD_WriteNumber19
;LCD.c,163 :: 		hundreds++;
	INCF       LCD_WriteNumber_hundreds_L0+0, 1
;LCD.c,164 :: 		num -= 100;
	MOVLW      100
	SUBWF      FARG_LCD_WriteNumber_num+0, 1
;LCD.c,165 :: 		}
	GOTO       L_LCD_WriteNumber18
L_LCD_WriteNumber19:
;LCD.c,166 :: 		tens = 0;
	CLRF       LCD_WriteNumber_tens_L0+0
;LCD.c,167 :: 		while (num >= 10) {
L_LCD_WriteNumber20:
	MOVLW      10
	SUBWF      FARG_LCD_WriteNumber_num+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_LCD_WriteNumber21
;LCD.c,168 :: 		tens++;
	INCF       LCD_WriteNumber_tens_L0+0, 1
;LCD.c,169 :: 		num -= 10;
	MOVLW      10
	SUBWF      FARG_LCD_WriteNumber_num+0, 1
;LCD.c,170 :: 		}
	GOTO       L_LCD_WriteNumber20
L_LCD_WriteNumber21:
;LCD.c,171 :: 		ones = (u8)num;
	MOVF       FARG_LCD_WriteNumber_num+0, 0
	MOVWF      LCD_WriteNumber_ones_L0+0
;LCD.c,173 :: 		if (hundreds > 0) {
	MOVF       LCD_WriteNumber_hundreds_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_LCD_WriteNumber22
;LCD.c,174 :: 		LCD_Send_Data('0' + hundreds);
	MOVF       LCD_WriteNumber_hundreds_L0+0, 0
	ADDLW      48
	MOVWF      FARG_LCD_LCD_Send_Data_dat+0
	CALL       LCD_LCD_Send_Data+0
;LCD.c,175 :: 		leading = 1;
	MOVLW      1
	MOVWF      LCD_WriteNumber_leading_L0+0
;LCD.c,176 :: 		}
L_LCD_WriteNumber22:
;LCD.c,177 :: 		if (tens > 0 || leading) {
	MOVF       LCD_WriteNumber_tens_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__LCD_WriteNumber27
	MOVF       LCD_WriteNumber_leading_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__LCD_WriteNumber27
	GOTO       L_LCD_WriteNumber25
L__LCD_WriteNumber27:
;LCD.c,178 :: 		LCD_Send_Data('0' + tens);
	MOVF       LCD_WriteNumber_tens_L0+0, 0
	ADDLW      48
	MOVWF      FARG_LCD_LCD_Send_Data_dat+0
	CALL       LCD_LCD_Send_Data+0
;LCD.c,179 :: 		}
L_LCD_WriteNumber25:
;LCD.c,180 :: 		LCD_Send_Data('0' + ones);
	MOVF       LCD_WriteNumber_ones_L0+0, 0
	ADDLW      48
	MOVWF      FARG_LCD_LCD_Send_Data_dat+0
	CALL       LCD_LCD_Send_Data+0
;LCD.c,181 :: 		}
L_end_LCD_WriteNumber:
	RETURN
; end of _LCD_WriteNumber
