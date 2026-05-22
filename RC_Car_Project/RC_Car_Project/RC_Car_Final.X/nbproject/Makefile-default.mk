#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../MCAL/UART/UART_interface.c ../MCAL/TMR1/TMR1_Interface.c ../MCAL/PWM/PWM_interface.c ../MCAL/Interrupt_Manager/Interrupt_manager.c ../MCAL/I2C/I2C.c ../MCAL/GPIO/GPIO.c ../MCAL/EXT_INT/EXT_INT.c ../HAL/Switch/Switch.c ../HAL/Motor/Motor.c ../HAL/LCD/LCD.c ../HAL/HC-SR04/SR04.c ../HAL/Bluetooth/Bluetooth.c ../APP/main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1209595571/UART_interface.p1 ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 ${OBJECTDIR}/_ext/1762084091/I2C.p1 ${OBJECTDIR}/_ext/1209998514/GPIO.p1 ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 ${OBJECTDIR}/_ext/251300383/Switch.p1 ${OBJECTDIR}/_ext/417979434/Motor.p1 ${OBJECTDIR}/_ext/272192830/LCD.p1 ${OBJECTDIR}/_ext/777610442/SR04.p1 ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 ${OBJECTDIR}/_ext/1360888114/main.p1
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d ${OBJECTDIR}/_ext/1762084091/I2C.p1.d ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d ${OBJECTDIR}/_ext/251300383/Switch.p1.d ${OBJECTDIR}/_ext/417979434/Motor.p1.d ${OBJECTDIR}/_ext/272192830/LCD.p1.d ${OBJECTDIR}/_ext/777610442/SR04.p1.d ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d ${OBJECTDIR}/_ext/1360888114/main.p1.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1209595571/UART_interface.p1 ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 ${OBJECTDIR}/_ext/1762084091/I2C.p1 ${OBJECTDIR}/_ext/1209998514/GPIO.p1 ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 ${OBJECTDIR}/_ext/251300383/Switch.p1 ${OBJECTDIR}/_ext/417979434/Motor.p1 ${OBJECTDIR}/_ext/272192830/LCD.p1 ${OBJECTDIR}/_ext/777610442/SR04.p1 ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 ${OBJECTDIR}/_ext/1360888114/main.p1

# Source Files
SOURCEFILES=../MCAL/UART/UART_interface.c ../MCAL/TMR1/TMR1_Interface.c ../MCAL/PWM/PWM_interface.c ../MCAL/Interrupt_Manager/Interrupt_manager.c ../MCAL/I2C/I2C.c ../MCAL/GPIO/GPIO.c ../MCAL/EXT_INT/EXT_INT.c ../HAL/Switch/Switch.c ../HAL/Motor/Motor.c ../HAL/LCD/LCD.c ../HAL/HC-SR04/SR04.c ../HAL/Bluetooth/Bluetooth.c ../APP/main.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16F877A
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1209595571/UART_interface.p1: ../MCAL/UART/UART_interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209595571" 
	@${RM} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209595571/UART_interface.p1 ../MCAL/UART/UART_interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1209595571/UART_interface.d ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1: ../MCAL/TMR1/TMR1_Interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209613865" 
	@${RM} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 ../MCAL/TMR1/TMR1_Interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.d ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1762091975/PWM_interface.p1: ../MCAL/PWM/PWM_interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1762091975" 
	@${RM} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 ../MCAL/PWM/PWM_interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1762091975/PWM_interface.d ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1: ../MCAL/Interrupt_Manager/Interrupt_manager.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/25208946" 
	@${RM} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d 
	@${RM} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 ../MCAL/Interrupt_Manager/Interrupt_manager.c 
	@-${MV} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.d ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1762084091/I2C.p1: ../MCAL/I2C/I2C.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1762084091" 
	@${RM} ${OBJECTDIR}/_ext/1762084091/I2C.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1762084091/I2C.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1762084091/I2C.p1 ../MCAL/I2C/I2C.c 
	@-${MV} ${OBJECTDIR}/_ext/1762084091/I2C.d ${OBJECTDIR}/_ext/1762084091/I2C.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1762084091/I2C.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1209998514/GPIO.p1: ../MCAL/GPIO/GPIO.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209998514" 
	@${RM} ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209998514/GPIO.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209998514/GPIO.p1 ../MCAL/GPIO/GPIO.c 
	@-${MV} ${OBJECTDIR}/_ext/1209998514/GPIO.d ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/940481358/EXT_INT.p1: ../MCAL/EXT_INT/EXT_INT.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/940481358" 
	@${RM} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d 
	@${RM} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 ../MCAL/EXT_INT/EXT_INT.c 
	@-${MV} ${OBJECTDIR}/_ext/940481358/EXT_INT.d ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/251300383/Switch.p1: ../HAL/Switch/Switch.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/251300383" 
	@${RM} ${OBJECTDIR}/_ext/251300383/Switch.p1.d 
	@${RM} ${OBJECTDIR}/_ext/251300383/Switch.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/251300383/Switch.p1 ../HAL/Switch/Switch.c 
	@-${MV} ${OBJECTDIR}/_ext/251300383/Switch.d ${OBJECTDIR}/_ext/251300383/Switch.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/251300383/Switch.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/417979434/Motor.p1: ../HAL/Motor/Motor.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/417979434" 
	@${RM} ${OBJECTDIR}/_ext/417979434/Motor.p1.d 
	@${RM} ${OBJECTDIR}/_ext/417979434/Motor.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/417979434/Motor.p1 ../HAL/Motor/Motor.c 
	@-${MV} ${OBJECTDIR}/_ext/417979434/Motor.d ${OBJECTDIR}/_ext/417979434/Motor.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/417979434/Motor.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/272192830/LCD.p1: ../HAL/LCD/LCD.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/272192830" 
	@${RM} ${OBJECTDIR}/_ext/272192830/LCD.p1.d 
	@${RM} ${OBJECTDIR}/_ext/272192830/LCD.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/272192830/LCD.p1 ../HAL/LCD/LCD.c 
	@-${MV} ${OBJECTDIR}/_ext/272192830/LCD.d ${OBJECTDIR}/_ext/272192830/LCD.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/272192830/LCD.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/777610442/SR04.p1: ../HAL/HC-SR04/SR04.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/777610442" 
	@${RM} ${OBJECTDIR}/_ext/777610442/SR04.p1.d 
	@${RM} ${OBJECTDIR}/_ext/777610442/SR04.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/777610442/SR04.p1 ../HAL/HC-SR04/SR04.c 
	@-${MV} ${OBJECTDIR}/_ext/777610442/SR04.d ${OBJECTDIR}/_ext/777610442/SR04.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/777610442/SR04.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/679314403/Bluetooth.p1: ../HAL/Bluetooth/Bluetooth.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/679314403" 
	@${RM} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d 
	@${RM} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 ../HAL/Bluetooth/Bluetooth.c 
	@-${MV} ${OBJECTDIR}/_ext/679314403/Bluetooth.d ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360888114/main.p1: ../APP/main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360888114" 
	@${RM} ${OBJECTDIR}/_ext/1360888114/main.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360888114/main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -mdebugger=none   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1360888114/main.p1 ../APP/main.c 
	@-${MV} ${OBJECTDIR}/_ext/1360888114/main.d ${OBJECTDIR}/_ext/1360888114/main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360888114/main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/_ext/1209595571/UART_interface.p1: ../MCAL/UART/UART_interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209595571" 
	@${RM} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209595571/UART_interface.p1 ../MCAL/UART/UART_interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1209595571/UART_interface.d ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209595571/UART_interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1: ../MCAL/TMR1/TMR1_Interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209613865" 
	@${RM} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1 ../MCAL/TMR1/TMR1_Interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.d ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209613865/TMR1_Interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1762091975/PWM_interface.p1: ../MCAL/PWM/PWM_interface.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1762091975" 
	@${RM} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1 ../MCAL/PWM/PWM_interface.c 
	@-${MV} ${OBJECTDIR}/_ext/1762091975/PWM_interface.d ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1762091975/PWM_interface.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1: ../MCAL/Interrupt_Manager/Interrupt_manager.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/25208946" 
	@${RM} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d 
	@${RM} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1 ../MCAL/Interrupt_Manager/Interrupt_manager.c 
	@-${MV} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.d ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/25208946/Interrupt_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1762084091/I2C.p1: ../MCAL/I2C/I2C.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1762084091" 
	@${RM} ${OBJECTDIR}/_ext/1762084091/I2C.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1762084091/I2C.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1762084091/I2C.p1 ../MCAL/I2C/I2C.c 
	@-${MV} ${OBJECTDIR}/_ext/1762084091/I2C.d ${OBJECTDIR}/_ext/1762084091/I2C.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1762084091/I2C.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1209998514/GPIO.p1: ../MCAL/GPIO/GPIO.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1209998514" 
	@${RM} ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1209998514/GPIO.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1209998514/GPIO.p1 ../MCAL/GPIO/GPIO.c 
	@-${MV} ${OBJECTDIR}/_ext/1209998514/GPIO.d ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1209998514/GPIO.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/940481358/EXT_INT.p1: ../MCAL/EXT_INT/EXT_INT.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/940481358" 
	@${RM} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d 
	@${RM} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/940481358/EXT_INT.p1 ../MCAL/EXT_INT/EXT_INT.c 
	@-${MV} ${OBJECTDIR}/_ext/940481358/EXT_INT.d ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/940481358/EXT_INT.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/251300383/Switch.p1: ../HAL/Switch/Switch.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/251300383" 
	@${RM} ${OBJECTDIR}/_ext/251300383/Switch.p1.d 
	@${RM} ${OBJECTDIR}/_ext/251300383/Switch.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/251300383/Switch.p1 ../HAL/Switch/Switch.c 
	@-${MV} ${OBJECTDIR}/_ext/251300383/Switch.d ${OBJECTDIR}/_ext/251300383/Switch.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/251300383/Switch.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/417979434/Motor.p1: ../HAL/Motor/Motor.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/417979434" 
	@${RM} ${OBJECTDIR}/_ext/417979434/Motor.p1.d 
	@${RM} ${OBJECTDIR}/_ext/417979434/Motor.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/417979434/Motor.p1 ../HAL/Motor/Motor.c 
	@-${MV} ${OBJECTDIR}/_ext/417979434/Motor.d ${OBJECTDIR}/_ext/417979434/Motor.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/417979434/Motor.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/272192830/LCD.p1: ../HAL/LCD/LCD.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/272192830" 
	@${RM} ${OBJECTDIR}/_ext/272192830/LCD.p1.d 
	@${RM} ${OBJECTDIR}/_ext/272192830/LCD.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/272192830/LCD.p1 ../HAL/LCD/LCD.c 
	@-${MV} ${OBJECTDIR}/_ext/272192830/LCD.d ${OBJECTDIR}/_ext/272192830/LCD.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/272192830/LCD.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/777610442/SR04.p1: ../HAL/HC-SR04/SR04.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/777610442" 
	@${RM} ${OBJECTDIR}/_ext/777610442/SR04.p1.d 
	@${RM} ${OBJECTDIR}/_ext/777610442/SR04.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/777610442/SR04.p1 ../HAL/HC-SR04/SR04.c 
	@-${MV} ${OBJECTDIR}/_ext/777610442/SR04.d ${OBJECTDIR}/_ext/777610442/SR04.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/777610442/SR04.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/679314403/Bluetooth.p1: ../HAL/Bluetooth/Bluetooth.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/679314403" 
	@${RM} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d 
	@${RM} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/679314403/Bluetooth.p1 ../HAL/Bluetooth/Bluetooth.c 
	@-${MV} ${OBJECTDIR}/_ext/679314403/Bluetooth.d ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/679314403/Bluetooth.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/_ext/1360888114/main.p1: ../APP/main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1360888114" 
	@${RM} ${OBJECTDIR}/_ext/1360888114/main.p1.d 
	@${RM} ${OBJECTDIR}/_ext/1360888114/main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     -o ${OBJECTDIR}/_ext/1360888114/main.p1 ../APP/main.c 
	@-${MV} ${OBJECTDIR}/_ext/1360888114/main.d ${OBJECTDIR}/_ext/1360888114/main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/_ext/1360888114/main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -mdebugger=none  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto        $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	@${RM} ${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.hex 
	
	
else
${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -I"../SERVICES" -I"../MCAL" -I"../HAL" -I"../APP" -mwarn=-3 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx32 -Wl,--data-init -mno-keep-startup -mno-osccal -mno-resetbits -mno-save-resetbits -mno-download -mno-stackcall -mno-default-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/RC_Car_Final.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
