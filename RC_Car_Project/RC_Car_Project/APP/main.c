//#include <xc.h>
//#include "../SERVICES/config.h"
//#include "../SERVICES/STD_TYPES.h"
//#include "../HAL/LCD/LCD.h"
//#include "../HAL/HC-SR04/SR04.h"
//#include "../HAL/Motor/Motor_interface.h"
//#include "../HAL/Bluetooth/Bluetooth.h" /* Your excellent custom Bluetooth driver */
//
//#pragma config FOSC  = HS
//#pragma config WDTE  = OFF
//#pragma config PWRTE = ON
//#pragma config BOREN = OFF
//#pragma config LVP   = OFF
//
///* Safety Inputs mapped to PORTA */
//#define DOOR_PIN PORTAbits.RA0
//#define BELT_PIN PORTAbits.RA1
//#define OBSTACLE_DIST 30 
//
//typedef enum { STATE_SAFE, STATE_DOOR_OPEN, STATE_NO_BELT } SystemState;
//
//void Display_Distance(u16 dist) {
//    if (dist == 999U) LCD_WriteString("--- "); 
//    else              { LCD_WriteNumber(dist); LCD_WriteString("  "); }
//}
//
//void main(void)
//{
//    /* --- 1. INITIALIZATION --- */
//    ADCON1 = 0x07; 
//    TRISAbits.TRISA0 = 1;
//    TRISAbits.TRISA1 = 1;
//
//    LCD_Init();
//    __delay_ms(50);
//    SR04_Init(); 
//    Motor_Init();
//    Motor_Stop(); 
//    
//    /* Initialize UART and Bluetooth at 9600 baud */
//    BT_Init(); 
//
//    LCD_Clear();
//    LCD_SetCursor(0, 0);
//    LCD_WriteString("RC Car Online");
//    LCD_SetCursor(1, 0);
//    LCD_WriteString("BT Connected..");
//    __delay_ms(1500);
//
//    u16 f = 0, l = 0, r = 0;
//    u16 old_f = 999, old_l = 999, old_r = 999;
//    SystemState current_state = STATE_SAFE;
//    SystemState previous_state = 99; 
//    
//    /* Pointer to hold the current status string for Bluetooth */
//    const char* state_str = BT_STATE_STOPPED;
//
//    while (1)
//    {
//        /* --- 2. SAFETY CHECK PHASE --- */
//        if (DOOR_PIN == 1)      current_state = STATE_DOOR_OPEN;
//        else if (BELT_PIN == 1) current_state = STATE_NO_BELT;
//        else                    current_state = STATE_SAFE;
//
//        /* --- 3. UI OVERRIDE & MOTOR KILL SWITCH --- */
//        if (current_state != previous_state) 
//        {
//            LCD_Clear();
//            if (current_state == STATE_DOOR_OPEN) 
//            {
//                Motor_Stop(); 
//                state_str = BT_STATE_DOOR_OPEN;
//                LCD_SetCursor(0, 0); LCD_WriteString("!! DOOR OPEN !!");
//                LCD_SetCursor(1, 0); LCD_WriteString("Car is LOCKED");
//            } 
//            else if (current_state == STATE_NO_BELT) 
//            {
//                Motor_Stop(); 
//                state_str = BT_STATE_NOSEATBELT;
//                LCD_SetCursor(0, 0); LCD_WriteString("!! NO SEATBELT !");
//                LCD_SetCursor(1, 0); LCD_WriteString("Fasten belt 1st");
//            } 
//            else if (current_state == STATE_SAFE) 
//            {
//                LCD_SetCursor(0, 0); LCD_WriteString("F: ---  ");
//                LCD_SetCursor(1, 0); LCD_WriteString("L:---   R:---");
//                old_f = 999; old_l = 999; old_r = 999; 
//            }
//            previous_state = current_state;
//            __delay_ms(200); 
//        }
//
//        /* --- 4. AUTONOMOUS DRIVING PHASE --- */
//        if (current_state == STATE_SAFE) 
//        {
//            f = SR04_GetDistance(SR04_FRONT); __delay_ms(10); 
//            l = SR04_GetDistance(SR04_LEFT);  __delay_ms(10);
//            r = SR04_GetDistance(SR04_RIGHT); __delay_ms(10);
//
//            if (f != old_f) { LCD_SetCursor(0, 3);  Display_Distance(f); old_f = f; }
//            if (l != old_l) { LCD_SetCursor(1, 2);  Display_Distance(l); old_l = l; }
//            if (r != old_r) { LCD_SetCursor(1, 10); Display_Distance(r); old_r = r; }
//
//            if (f > OBSTACLE_DIST) 
//            {
//                Motor_Forward();
//                state_str = BT_STATE_MOVING;
//            }
//            else 
//            {
//                Motor_Stop();
//                state_str = BT_STATE_OBSTACLE; /* Temporarily blocked */
//                __delay_ms(200);
//
//                if (l > r && l > OBSTACLE_DIST) 
//                {
//                    Motor_Turn_Left();
//                    state_str = BT_STATE_TURNING_L;
//                    __delay_ms(400); 
//                    Motor_Stop();
//                }
//                else if (r > l && r > OBSTACLE_DIST) 
//                {
//                    Motor_Turn_Right();
//                    state_str = BT_STATE_TURNING_R;
//                    __delay_ms(400); 
//                    Motor_Stop();
//                }
//                else 
//                {
//                    Motor_Reverse();
//                    state_str = BT_STATE_TURNING_R; /* Spinning out of corner */
//                    __delay_ms(600); 
//                    Motor_Turn_Right();   
//                    __delay_ms(600); 
//                    Motor_Stop();
//                }
//            }
//        }
//
//        /* --- 5. BLUETOOTH TELEMETRY LOGGING --- */
//        /* * DOOR_PIN == 0 means door is closed (1 means OPEN)
//         * BELT_PIN == 0 means belt is fastened (1 means UNBUCKLED)
//         * Passes the formatted data straight to your Bluetooth.c driver
//         */
//        BT_SendLog((DOOR_PIN == 0), (BELT_PIN == 0), f, l, r, state_str);
//
//        __delay_ms(50);
//    }
//}
/*-----------------------------------------------------------------*/
/////////////////////////////////////////////////////////////////////
//#include <xc.h>
//#include <stdio.h>      /* Required for sprintf */
//#include "../SERVICES/config.h"
//#include "../SERVICES/STD_TYPES.h"
//#include "../HAL/LCD/LCD.h"
//#include "../HAL/HC-SR04/SR04.h"
//#include "../HAL/Motor/Motor_interface.h"
//#include "../MCAL/UART/UART_interface.h"
//
//#pragma config FOSC  = HS
//#pragma config WDTE  = OFF
//#pragma config PWRTE = ON
//#pragma config BOREN = OFF
//#pragma config LVP   = OFF
//
///* Safety Inputs mapped to PORTA */
//#define DOOR_PIN PORTAbits.RA0
//#define BELT_PIN PORTAbits.RA1
//#define OBSTACLE_DIST 30 
//
//typedef enum { STATE_SAFE, STATE_DOOR_OPEN, STATE_NO_BELT } SystemState;
//
//void Display_Distance(u16 dist) {
//    if (dist == 999U) LCD_WriteString("--- "); 
//    else              { LCD_WriteNumber(dist); LCD_WriteString("  "); }
//}
//
//void main(void)
//{
//    /* --- 1. INITIALIZATION --- */
//    ADCON1 = 0x07; 
//    TRISAbits.TRISA0 = 1;
//    TRISAbits.TRISA1 = 1;
//
//    LCD_Init();
//    __delay_ms(50);
//    SR04_Init(); 
//    Motor_Init();
//    Motor_Stop(); 
//    UART_Init(9600); /* Initializes UART instead of Bluetooth */
//
//    LCD_Clear();
//    LCD_SetCursor(0, 0);
//    LCD_WriteString("RC Car Online");
//    LCD_SetCursor(1, 0);
//    LCD_WriteString("UART Connected.."); 
//    __delay_ms(1500);
//
//    u16 f = 0, l = 0, r = 0;
//    u16 old_f = 999, old_l = 999, old_r = 999;
//    char uart_buffer[64]; 
//    SystemState current_state = STATE_SAFE;
//    SystemState previous_state = 99; 
//
//    while (1)
//    {
//        /* --- 2. SAFETY CHECK PHASE --- */
//        if (DOOR_PIN == 1)      current_state = STATE_DOOR_OPEN;
//        else if (BELT_PIN == 1) current_state = STATE_NO_BELT;
//        else                    current_state = STATE_SAFE;
//
//        /* --- 3. UI OVERRIDE & MOTOR KILL SWITCH --- */
//        if (current_state != previous_state) 
//        {
//            LCD_Clear();
//            if (current_state == STATE_DOOR_OPEN) 
//            {
//                Motor_Stop(); 
//                LCD_SetCursor(0, 0); LCD_WriteString("!! DOOR OPEN !!");
//                LCD_SetCursor(1, 0); LCD_WriteString("Car is LOCKED");
//            } 
//            else if (current_state == STATE_NO_BELT) 
//            {
//                Motor_Stop(); 
//                LCD_SetCursor(0, 0); LCD_WriteString("!! NO SEATBELT !");
//                LCD_SetCursor(1, 0); LCD_WriteString("Fasten belt 1st");
//            } 
//            else if (current_state == STATE_SAFE) 
//            {
//                LCD_SetCursor(0, 0); LCD_WriteString("F: ---  ");
//                LCD_SetCursor(1, 0); LCD_WriteString("L:---   R:---");
//                old_f = 999; old_l = 999; old_r = 999; 
//            }
//            previous_state = current_state;
//            __delay_ms(200); 
//        }
//
//        /* --- 4. AUTONOMOUS DRIVING PHASE --- */
//        if (current_state == STATE_SAFE) 
//        {
//            f = SR04_GetDistance(SR04_FRONT); __delay_ms(10); 
//            l = SR04_GetDistance(SR04_LEFT);  __delay_ms(10);
//            r = SR04_GetDistance(SR04_RIGHT); __delay_ms(10);
//
//            if (f != old_f) { LCD_SetCursor(0, 3);  Display_Distance(f); old_f = f; }
//            if (l != old_l) { LCD_SetCursor(1, 2);  Display_Distance(l); old_l = l; }
//            if (r != old_r) { LCD_SetCursor(1, 10); Display_Distance(r); old_r = r; }
//
//            if (f > OBSTACLE_DIST) 
//            {
//                Motor_Forward();
//            }
//            else 
//            {
//                Motor_Stop();
//                __delay_ms(200);
//
//                if (l > r && l > OBSTACLE_DIST) 
//                {
//                    Motor_Turn_Left();
//                    __delay_ms(400); 
//                    Motor_Stop();
//                }
//                else if (r > l && r > OBSTACLE_DIST) 
//                {
//                    Motor_Turn_Right();
//                    __delay_ms(400); 
//                    Motor_Stop();
//                }
//                else 
//                {
//                    Motor_Reverse();
//                    __delay_ms(600); 
//                    Motor_Turn_Right();   
//                    __delay_ms(600); 
//                    Motor_Stop();
//                }
//            }
//        }
//
//        /* --- 5. UART TELEMETRY TO RASPBERRY PI --- */
//        /* SAFELY store the bit-field values into 8-bit integers FIRST.
//           This completely prevents the memory corruption in sprintf() */
//        u8 current_door = DOOR_PIN;
//        u8 current_belt = BELT_PIN;
//
//        /* Format string exactly how Python expects: F:xxx R:xxx L:xxx D:x B:x */
//        sprintf(uart_buffer, "F:%03u R:%03u L:%03u D:%u B:%u\n",
//                f, r, l, current_door, current_belt);
//        
//        UART_SendString(uart_buffer);
//
//        __delay_ms(50);
//    }
//}
/*-----------------------------------------------------------------*/
//#include <xc.h>
//#include "../SERVICES/config.h"
//#include "../SERVICES/STD_TYPES.h"
//#include "../MCAL/UART/UART_interface.h"
//#include "../HAL/LCD/LCD.h"
//#include "../HAL/Motor/Motor_interface.h"
//
//#pragma config FOSC  = HS
//#pragma config WDTE  = OFF
//#pragma config PWRTE = ON
//#pragma config BOREN = OFF
//#pragma config LVP   = OFF
//
//void main(void)
//{
//    ADCON1 = 0x07;
//
//    LCD_Init();
//    Motor_Init();
//    Motor_Stop();
//
//    __delay_ms(200);
//    UART_Init(9600);
//    __delay_ms(100);
//
//    LCD_Clear();
//    LCD_SetCursor(0, 0);
//    LCD_WriteString("UART Test Ready");
//    LCD_SetCursor(1, 0);
//    LCD_WriteString("Waiting cmd...");
//
//    UART_SendString("PIC BOOT OK\n");
//
//    while (1)
//    {
//        if (UART_DataAvailable())
//        {
//            u8 cmd = UART_ReceiveChar();
//
//            UART_SendChar(cmd);
//            UART_SendString(" OK\n");
//
//            LCD_SetCursor(0, 0);
//            switch (cmd)
//            {
//                case 'F':
//                    Motor_Forward();
//                    LCD_WriteString("CMD: FORWARD    ");
//                    break;
//                case 'B':
//                    Motor_Reverse();
//                    LCD_WriteString("CMD: REVERSE    ");
//                    break;
//                case 'L':
//                    Motor_Turn_Left();
//                    LCD_WriteString("CMD: LEFT       ");
//                    break;
//                case 'R':
//                    Motor_Turn_Right();
//                    LCD_WriteString("CMD: RIGHT      ");
//                    break;
//                case 'S':
//                default:
//                    Motor_Stop();
//                    LCD_WriteString("CMD: STOP       ");
//                    break;
//            }
//
//            LCD_SetCursor(1, 0);
//            LCD_WriteString("Got:");
//            LCD_WriteNumber((u16)cmd);
//            LCD_WriteString("        ");
//        }
//    }
//}
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-//
//#include <xc.h>
//#include "../SERVICES/config.h"
//#include "../SERVICES/STD_TYPES.h"
//#include "../MCAL/UART/UART_interface.h"
//#include "../HAL/LCD/LCD.h"
//#include "../HAL/HC-SR04/SR04.h"
//#include "../HAL/Motor/Motor_interface.h"
//
//#pragma config FOSC  = HS
//#pragma config WDTE  = OFF
//#pragma config PWRTE = ON
//#pragma config BOREN = OFF
//#pragma config LVP   = OFF
//
//#define DOOR_PIN      PORTAbits.RA0
//#define BELT_PIN      PORTAbits.RA1
//#define OBSTACLE_DIST 30
//
//typedef enum { STATE_SAFE, STATE_DOOR_OPEN, STATE_NO_BELT } SystemState;
//
//void Display_Distance(u16 dist)
//{
//    if (dist == 999U) LCD_WriteString("--- ");
//    else { LCD_WriteNumber(dist); LCD_WriteString("  "); }
//}
//
//void main(void)
//{
//    ADCON1 = 0x07;
//    TRISAbits.TRISA0 = 1;
//    TRISAbits.TRISA1 = 1;
//
//    LCD_Init();
//    __delay_ms(50);
//    SR04_Init();
//    Motor_Init();
//    Motor_Stop();
//
//    __delay_ms(200);
//    UART_Init(9600);
//    __delay_ms(100);
//
//    LCD_Clear();
//    LCD_SetCursor(0, 0);
//    LCD_WriteString("RC Car Online");
//    LCD_SetCursor(1, 0);
//    LCD_WriteString("Pi Link: OK");
//    __delay_ms(1500);
//
//    u16 f = 0, l = 0, r = 0;
//    u16 old_f = 999, old_l = 999, old_r = 999;
//    SystemState current_state  = STATE_SAFE;
//    SystemState previous_state = 99;
//
//    UART_SendString("BOOT:OK\n");
//
//    while (1)
//    {
//        /* Pull-up resistor to VCC on both pins:
//         * PIN == 0 -> switch closed -> shorted to GND -> triggered -> danger
//         * PIN == 1 -> switch open   -> pull-up holds HIGH          -> safe
//         */
//        if      (DOOR_PIN == 1) current_state = STATE_DOOR_OPEN;
//        else if (BELT_PIN == 0) current_state = STATE_NO_BELT;
//        else                    current_state = STATE_SAFE;
//
//        if (current_state != previous_state)
//        {
//            LCD_Clear();
//            if (current_state == STATE_DOOR_OPEN)
//            {
//                Motor_Stop();
//                LCD_SetCursor(0, 0); LCD_WriteString("!! DOOR OPEN !!");
//                LCD_SetCursor(1, 0); LCD_WriteString("Car is LOCKED  ");
//            }
//            else if (current_state == STATE_NO_BELT)
//            {
//                Motor_Stop();
//                LCD_SetCursor(0, 0); LCD_WriteString("!! NO SEATBELT !");
//                LCD_SetCursor(1, 0); LCD_WriteString("Fasten belt 1st");
//            }
//            else
//            {
//                LCD_SetCursor(0, 0); LCD_WriteString("F:---           ");
//                LCD_SetCursor(1, 0); LCD_WriteString("L:---    R:---  ");
//                old_f = 999; old_l = 999; old_r = 999;
//            }
//            previous_state = current_state;
//            __delay_ms(200);
//        }
//
//        if (current_state == STATE_SAFE)
//        {
//            f = SR04_GetDistance(SR04_FRONT); __delay_ms(10);
//            l = SR04_GetDistance(SR04_LEFT);  __delay_ms(10);
//            r = SR04_GetDistance(SR04_RIGHT); __delay_ms(10);
//
//            if (f != old_f) { LCD_SetCursor(0, 2);  Display_Distance(f); old_f = f; }
//            if (l != old_l) { LCD_SetCursor(1, 2);  Display_Distance(l); old_l = l; }
//            if (r != old_r) { LCD_SetCursor(1, 10); Display_Distance(r); old_r = r; }
//
//            if (f > OBSTACLE_DIST)
//            {
//                Motor_Forward();
//            }
//            else
//            {
//                Motor_Stop();
//                __delay_ms(200);
//
//                if (l > r && l > OBSTACLE_DIST)
//                {
//                    Motor_Turn_Left();
//                    __delay_ms(400);
//                    Motor_Stop();
//                }
//                else if (r > l && r > OBSTACLE_DIST)
//                {
//                    Motor_Turn_Right();
//                    __delay_ms(400);
//                    Motor_Stop();
//                }
//                else
//                {
//                    Motor_Reverse();
//                    __delay_ms(600);
//                    Motor_Turn_Right();
//                    __delay_ms(600);
//                    Motor_Stop();
//                }
//            }
//        }
//
//        /* D:1 = door closed (safe)    D:0 = door open
//         * B:1 = belt fastened (safe)  B:0 = unbuckled
//         * PIN==1 = safe because pull-up holds HIGH when switch open
//         */
//        UART_SendLog(
//            (DOOR_PIN == 0),
//            (BELT_PIN == 1),
//            f, l, r
//        );
//
//        __delay_ms(50);
//    }
//}
//#include <xc.h>
//#include "../SERVICES/config.h"
//#include "../SERVICES/STD_TYPES.h"
//#include "../MCAL/UART/UART_interface.h"
//#include "../HAL/LCD/LCD.h"
//#include "../HAL/HC-SR04/SR04.h"
//#include "../HAL/Motor/Motor_interface.h"
//
//#pragma config FOSC  = HS
//#pragma config WDTE  = OFF
//#pragma config PWRTE = ON
//#pragma config BOREN = OFF
//#pragma config LVP   = OFF
//
//#define DOOR_PIN      PORTAbits.RA0
//#define BELT_PIN      PORTAbits.RA1
//#define OBSTACLE_DIST 30
//
//typedef enum { STATE_SAFE, STATE_DOOR_OPEN, STATE_NO_BELT } SystemState;
//typedef enum { MODE_AUTO, MODE_MANUAL } DriveMode;
//
//void Display_Distance(u16 dist)
//{
//    if (dist == 999U) LCD_WriteString("--- ");
//    else { LCD_WriteNumber(dist); LCD_WriteString("  "); }
//}
//
//void main(void)
//{
//    ADCON1 = 0x07;
//    TRISAbits.TRISA0 = 1;
//    TRISAbits.TRISA1 = 1;
//
//    LCD_Init();
//    __delay_ms(50);
//    SR04_Init();
//    Motor_Init();
//    Motor_Stop();
//
//    __delay_ms(200);
//    UART_Init(9600);
//    __delay_ms(100);
//
//    LCD_Clear();
//    LCD_SetCursor(0, 0);
//    LCD_WriteString("RC Car Online");
//    LCD_SetCursor(1, 0);
//    LCD_WriteString("Pi Link: OK");
//    __delay_ms(1500);
//
//    u16 f = 0, l = 0, r = 0;
//    u16 old_f = 999, old_l = 999, old_r = 999;
//    SystemState current_state  = STATE_SAFE;
//    SystemState previous_state = 99;
//    DriveMode   drive_mode     = MODE_AUTO;
//
//    UART_SendString("BOOT:OK\n");
//
//    while (1)
//    {
//        /* --- CHECK FOR INCOMING COMMAND FROM PI --- */
//        if (UART_DataAvailable())
//        {
//            u8 cmd = UART_ReceiveChar();
//
//            if (cmd == 'M')
//            {
//                drive_mode = MODE_MANUAL;
//                Motor_Stop();
//                LCD_Clear();
//                LCD_SetCursor(0, 0); LCD_WriteString("Mode: MANUAL    ");
//                LCD_SetCursor(1, 0); LCD_WriteString("App Control     ");
//            }
//            else if (cmd == 'A')
//            {
//                drive_mode = MODE_AUTO;
//                Motor_Stop();
//                LCD_Clear();
//                LCD_SetCursor(0, 0); LCD_WriteString("Mode: AUTO      ");
//                LCD_SetCursor(1, 0); LCD_WriteString("Autonomous...   ");
//                old_f = 999; old_l = 999; old_r = 999;
//            }
//            else if (drive_mode == MODE_MANUAL)
//            {
//                /* Only act on movement commands in manual mode */
//                switch (cmd)
//                {
//                    case 'F':
//                        Motor_Forward();
//                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: FORWARD    ");
//                        break;
//                    case 'B':
//                        Motor_Reverse();
//                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: REVERSE    ");
//                        break;
//                    case 'L':
//                        Motor_Turn_Left();
//                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: LEFT       ");
//                        break;
//                    case 'R':
//                        Motor_Turn_Right();
//                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: RIGHT      ");
//                        break;
//                    case 'S':
//                        Motor_Stop();
//                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: STOP       ");
//                        break;
//                    default:
//                        break;
//                }
//            }
//        }
//
//        /* --- SAFETY CHECK --- */
//        if      (DOOR_PIN == 1) current_state = STATE_DOOR_OPEN;
//        else if (BELT_PIN == 0) current_state = STATE_NO_BELT;
//        else                    current_state = STATE_SAFE;
//
//        /* --- UI + MOTOR KILL ON STATE CHANGE --- */
//        if (current_state != previous_state)
//        {
//            LCD_Clear();
//            if (current_state == STATE_DOOR_OPEN)
//            {
//                Motor_Stop();
//                LCD_SetCursor(0, 0); LCD_WriteString("!! DOOR OPEN !!");
//                LCD_SetCursor(1, 0); LCD_WriteString("Car is LOCKED  ");
//            }
//            else if (current_state == STATE_NO_BELT)
//            {
//                Motor_Stop();
//                LCD_SetCursor(0, 0); LCD_WriteString("!! NO SEATBELT !");
//                LCD_SetCursor(1, 0); LCD_WriteString("Fasten belt 1st");
//            }
//            else
//            {
//                if (drive_mode == MODE_AUTO)
//                {
//                    LCD_SetCursor(0, 0); LCD_WriteString("F:---           ");
//                    LCD_SetCursor(1, 0); LCD_WriteString("L:---    R:---  ");
//                }
//                old_f = 999; old_l = 999; old_r = 999;
//            }
//            previous_state = current_state;
//            __delay_ms(200);
//        }
//
//        /* --- AUTONOMOUS DRIVING (only when safe and in AUTO mode) --- */
//        if (current_state == STATE_SAFE && drive_mode == MODE_AUTO)
//        {
//            f = SR04_GetDistance(SR04_FRONT); __delay_ms(10);
//            l = SR04_GetDistance(SR04_LEFT);  __delay_ms(10);
//            r = SR04_GetDistance(SR04_RIGHT); __delay_ms(10);
//
//            if (f != old_f) { LCD_SetCursor(0, 2);  Display_Distance(f); old_f = f; }
//            if (l != old_l) { LCD_SetCursor(1, 2);  Display_Distance(l); old_l = l; }
//            if (r != old_r) { LCD_SetCursor(1, 10); Display_Distance(r); old_r = r; }
//
//            if (f > OBSTACLE_DIST)
//            {
//                Motor_Forward();
//            }
//            else
//            {
//                Motor_Stop();
//                __delay_ms(200);
//
//                if (l > r && l > OBSTACLE_DIST)
//                {
//                    Motor_Turn_Left();
//                    __delay_ms(400);
//                    Motor_Stop();
//                }
//                else if (r > l && r > OBSTACLE_DIST)
//                {
//                    Motor_Turn_Right();
//                    __delay_ms(400);
//                    Motor_Stop();
//                }
//                else
//                {
//                    Motor_Reverse();
//                    __delay_ms(600);
//                    Motor_Turn_Right();
//                    __delay_ms(600);
//                    Motor_Stop();
//                }
//            }
//        }
//
//        /* --- TELEMETRY TO PI --- */
//        UART_SendLog(
//            (DOOR_PIN == 0),
//            (BELT_PIN == 1),
//            f, l, r
//        );
//
//        __delay_ms(50);
//    }
//}
//*/*/*/*/**/*/*/*/*/*/*/*-*-*-*-*-*-*-**-/*/*/*/*/*-*-*-*-*-*-*-

#include <xc.h>
#include "../SERVICES/config.h"
#include "../SERVICES/STD_TYPES.h"
#include "../MCAL/UART/UART_interface.h"
#include "../HAL/LCD/LCD.h"
#include "../HAL/HC-SR04/SR04.h"
#include "../HAL/Motor/Motor_interface.h"

#pragma config FOSC  = HS
#pragma config WDTE  = OFF
#pragma config PWRTE = ON
#pragma config BOREN = OFF
#pragma config LVP   = OFF

#define DOOR_PIN      PORTAbits.RA0
#define BELT_PIN      PORTAbits.RA1
#define OBSTACLE_DIST 30

typedef enum { STATE_SAFE, STATE_DOOR_OPEN, STATE_NO_BELT, STATE_EYES_CLOSED } SystemState;
typedef enum { MODE_AUTO, MODE_MANUAL } DriveMode;

u8 eyes_open = 1; // 1 = Open, 0 = Closed. Assume open on boot.

void Display_Distance(u16 dist)
{
    if (dist == 999U) LCD_WriteString("--- ");
    else { LCD_WriteNumber(dist); LCD_WriteString("  "); }
}

void main(void)
{
    ADCON1 = 0x07;
    TRISAbits.TRISA0 = 1;
    TRISAbits.TRISA1 = 1;

    LCD_Init();
    __delay_ms(50);
    SR04_Init();
    Motor_Init();
    Motor_Stop();

    __delay_ms(200);
    UART_Init(9600);
    __delay_ms(100);

    LCD_Clear();
    LCD_SetCursor(0, 0);
    LCD_WriteString("RC Car Online");
    LCD_SetCursor(1, 0);
    LCD_WriteString("Pi Link: OK");
    __delay_ms(1500);

    u16 f = 0, l = 0, r = 0;
    u16 old_f = 999, old_l = 999, old_r = 999;
    SystemState current_state  = STATE_SAFE;
    SystemState previous_state = 99;
    DriveMode   drive_mode     = MODE_AUTO;

    UART_SendString("BOOT:OK\n");

    while (1)
    {
        /* --- CHECK FOR INCOMING COMMAND FROM PI --- */
        if (UART_DataAvailable())
        {
            u8 cmd = UART_ReceiveChar();

            if (cmd == 'E') 
            { 
                eyes_open = 1; 
            }
            else if (cmd == 'C') 
            { 
                eyes_open = 0; 
            }
            else if (cmd == 'M')
            {
                drive_mode = MODE_MANUAL;
                Motor_Stop();
                LCD_Clear();
                LCD_SetCursor(0, 0); LCD_WriteString("Mode: MANUAL    ");
                LCD_SetCursor(1, 0); LCD_WriteString("App Control     ");
            }
            else if (cmd == 'A')
            {
                drive_mode = MODE_AUTO;
                Motor_Stop();
                LCD_Clear();
                LCD_SetCursor(0, 0); LCD_WriteString("Mode: AUTO      ");
                LCD_SetCursor(1, 0); LCD_WriteString("Autonomous...   ");
                old_f = 999; old_l = 999; old_r = 999;
            }
            else if (drive_mode == MODE_MANUAL)
            {
                /* Only act on movement commands in manual mode */
                switch (cmd)
                {
                    case 'F':
                        Motor_Forward();
                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: FORWARD    ");
                        break;
                    case 'B':
                        Motor_Reverse();
                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: REVERSE    ");
                        break;
                    case 'L':
                        Motor_Turn_Left();
                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: LEFT       ");
                        break;
                    case 'R':
                        Motor_Turn_Right();
                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: RIGHT      ");
                        break;
                    case 'S':
                        Motor_Stop();
                        LCD_SetCursor(0, 0); LCD_WriteString("CMD: STOP       ");
                        break;
                    default:
                        break;
                }
            }
        }

        /* --- SAFETY CHECK --- */
        if      (DOOR_PIN == 1)  current_state = STATE_DOOR_OPEN;
        else if (BELT_PIN == 0)  current_state = STATE_NO_BELT;
        else if (eyes_open == 0) current_state = STATE_EYES_CLOSED;
        else                     current_state = STATE_SAFE;

        /* --- UI + MOTOR KILL ON STATE CHANGE --- */
        if (current_state != previous_state)
        {
            LCD_Clear();
            if (current_state == STATE_DOOR_OPEN)
            {
                Motor_Stop();
                LCD_SetCursor(0, 0); LCD_WriteString("!! DOOR OPEN !!");
                LCD_SetCursor(1, 0); LCD_WriteString("Car is LOCKED  ");
            }
            else if (current_state == STATE_NO_BELT)
            {
                Motor_Stop();
                LCD_SetCursor(0, 0); LCD_WriteString("!! NO SEATBELT !");
                LCD_SetCursor(1, 0); LCD_WriteString("Fasten belt 1st");
            }
            else if (current_state == STATE_EYES_CLOSED)
            {
                Motor_Stop();
                LCD_SetCursor(0, 0); LCD_WriteString("!! DROWSY DRIVER");
                LCD_SetCursor(1, 0); LCD_WriteString("Eyes Closed!    ");
            }
            else
            {
                if (drive_mode == MODE_AUTO)
                {
                    LCD_SetCursor(0, 0); LCD_WriteString("F:---           ");
                    LCD_SetCursor(1, 0); LCD_WriteString("L:---    R:---  ");
                }
                old_f = 999; old_l = 999; old_r = 999;
            }
            previous_state = current_state;
            __delay_ms(200);
        }

        /* --- AUTONOMOUS DRIVING (only when safe and in AUTO mode) --- */
        if (current_state == STATE_SAFE && drive_mode == MODE_AUTO)
        {
            f = SR04_GetDistance(SR04_FRONT); __delay_ms(10);
            l = SR04_GetDistance(SR04_LEFT);  __delay_ms(10);
            r = SR04_GetDistance(SR04_RIGHT); __delay_ms(10);

            if (f != old_f) { LCD_SetCursor(0, 2);  Display_Distance(f); old_f = f; }
            if (l != old_l) { LCD_SetCursor(1, 2);  Display_Distance(l); old_l = l; }
            if (r != old_r) { LCD_SetCursor(1, 10); Display_Distance(r); old_r = r; }

            if (f > OBSTACLE_DIST)
            {
                Motor_Forward();
            }
            else
            {
                Motor_Stop();
                __delay_ms(200);

                if (l > r && l > OBSTACLE_DIST)
                {
                    Motor_Turn_Left();
                    __delay_ms(400);
                    Motor_Stop();
                }
                else if (r > l && r > OBSTACLE_DIST)
                {
                    Motor_Turn_Right();
                    __delay_ms(400);
                    Motor_Stop();
                }
                else
                {
                    Motor_Reverse();
                    __delay_ms(600);
                    Motor_Turn_Right();
                    __delay_ms(600);
                    Motor_Stop();
                }
            }
        }

        /* --- TELEMETRY TO PI --- */
        UART_SendLog(
            (DOOR_PIN == 0),
            (BELT_PIN == 1),
            f, l, r
        );

        __delay_ms(50);
    }
}