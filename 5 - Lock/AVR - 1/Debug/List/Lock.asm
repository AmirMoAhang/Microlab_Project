
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x31,0x31,0x31,0x31,0x31
_0x52:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x4C,0x4F,0x43
	.DB  0x4B,0x45,0x44,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x0,0x2D,0x2D,0x2D,0x2D,0x55,0x4E,0x4C
	.DB  0x4F,0x43,0x4B,0x45,0x44,0x2D,0x2D,0x2D
	.DB  0x2D,0x0,0x2D,0x2D,0x2D,0x2D,0x2D,0x57
	.DB  0x52,0x4F,0x4E,0x47,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x0,0x2D,0x2D,0x63,0x75,0x72
	.DB  0x72,0x65,0x6E,0x74,0x20,0x70,0x61,0x73
	.DB  0x73,0x2D,0x2D,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x4E,0x65,0x77,0x20,0x50,0x61,0x73,0x73
	.DB  0x2D,0x2D,0x2D,0x2D,0x0,0x2D,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x35,0x20,0x44,0x69
	.DB  0x67,0x69,0x74,0x73,0x2D,0x0,0x52,0x45
	.DB  0x65,0x6E,0x74,0x65,0x72,0x20,0x6E,0x65
	.DB  0x77,0x20,0x70,0x61,0x73,0x73,0x0,0x2D
	.DB  0x2D,0x50,0x61,0x73,0x73,0x20,0x63,0x68
	.DB  0x61,0x6E,0x67,0x65,0x64,0x2D,0x2D,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _Password
	.DW  _0x3*2

	.DW  0x11
	.DW  _0x7
	.DW  _0x0*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;#include <eeprom.h>
;
;char GetKey();
;void changePass();
;void checkPassFromEEPROM();
;
;char Password[] = "11111";

	.DSEG
;
;
;void main(void)
; 0000 0010 {

	.CSEG
_main:
; .FSTART _main
; 0000 0011     char inputPass[6] = "";
; 0000 0012     char passIndex = 0;
; 0000 0013     char locked = 1;
; 0000 0014     char k;
; 0000 0015 
; 0000 0016     lcd_init(16);
	SBIW R28,6
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
;	inputPass -> Y+0
;	passIndex -> R17
;	locked -> R16
;	k -> R19
	LDI  R17,0
	LDI  R16,1
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0017     lcd_clear();
	RCALL _lcd_clear
; 0000 0018 
; 0000 0019     DDRD = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 001A     PORTD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 001B     DDRC = 0x03;
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 001C     PORTC = 0x02;
	LDI  R30,LOW(2)
	OUT  0x15,R30
; 0000 001D 
; 0000 001E     checkPassFromEEPROM();
	RCALL _checkPassFromEEPROM
; 0000 001F     while (1)
_0x4:
; 0000 0020         {
; 0000 0021             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
; 0000 0022             lcd_puts("-----LOCKED-----");
	__POINTW2MN _0x7,0
	RCALL _lcd_puts
; 0000 0023 
; 0000 0024             while(1)
_0x8:
; 0000 0025             {
; 0000 0026                 k = GetKey();
	RCALL _GetKey
	MOV  R19,R30
; 0000 0027                 if(k != 16) break;
	CPI  R19,16
	BREQ _0x8
; 0000 0028             }
; 0000 0029 
; 0000 002A             if(k == 10)
	CPI  R19,10
	BRNE _0xC
; 0000 002B             {
; 0000 002C                 while(GetKey() != 16);
_0xD:
	RCALL SUBOPT_0x1
	BRNE _0xD
; 0000 002D                 strcpyf(inputPass,"");
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 002E                 passIndex = 0;
; 0000 002F             }
; 0000 0030             else if(k == 11)
	RJMP _0x10
_0xC:
	CPI  R19,11
	BRNE _0x11
; 0000 0031             {
; 0000 0032                 while(GetKey() != 16);
_0x12:
	RCALL SUBOPT_0x1
	BRNE _0x12
; 0000 0033                 inputPass[passIndex] = '\0';
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0034                 if(strcmp(inputPass, Password) == 0)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	BRNE _0x15
; 0000 0035                 {
; 0000 0036                     locked = 0;
	LDI  R16,LOW(0)
; 0000 0037                     PORTC = 0x01;
	LDI  R30,LOW(1)
	OUT  0x15,R30
; 0000 0038                     lcd_clear();
	RCALL SUBOPT_0x7
; 0000 0039                     lcd_gotoxy(0,0);
; 0000 003A                     lcd_putsf("----UNLOCKED----");
	__POINTW2FN _0x0,17
	RCALL _lcd_putsf
; 0000 003B                     while(1)
_0x16:
; 0000 003C                     {
; 0000 003D                         k = GetKey();
	RCALL _GetKey
	MOV  R19,R30
; 0000 003E                         if(k == 16) continue;
	CPI  R19,16
	BREQ _0x16
; 0000 003F                         else if (k == 10)
	CPI  R19,10
	BRNE _0x1B
; 0000 0040                         {
; 0000 0041                             // new pass
; 0000 0042                             changePass();
	RCALL _changePass
; 0000 0043                             PORTC = 0x02;
	LDI  R30,LOW(2)
	OUT  0x15,R30
; 0000 0044                             break;
	RJMP _0x18
; 0000 0045                         }
; 0000 0046                         else if(k == 11)
_0x1B:
	CPI  R19,11
	BRNE _0x1D
; 0000 0047                         {
; 0000 0048                             PORTC = 0x02;
	LDI  R30,LOW(2)
	OUT  0x15,R30
; 0000 0049                             break;
	RJMP _0x18
; 0000 004A                         }
; 0000 004B                     }
_0x1D:
	RJMP _0x16
_0x18:
; 0000 004C 
; 0000 004D                 }
; 0000 004E                 else
	RJMP _0x1E
_0x15:
; 0000 004F                 {
; 0000 0050                     lcd_clear();
	RCALL SUBOPT_0x7
; 0000 0051                     lcd_gotoxy(0,0);
; 0000 0052                     lcd_putsf("-----WRONG------");
	RCALL SUBOPT_0x8
; 0000 0053                     delay_ms(2000);
; 0000 0054 
; 0000 0055                 }
_0x1E:
; 0000 0056                 strcpyf(inputPass, "");
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 0057                 passIndex = 0;
; 0000 0058             }
; 0000 0059             else
	RJMP _0x1F
_0x11:
; 0000 005A             {
; 0000 005B                 while(GetKey()!= 16);
_0x20:
	RCALL SUBOPT_0x1
	BRNE _0x20
; 0000 005C                 if(passIndex < sizeof(inputPass) - 1)
	CPI  R17,5
	BRSH _0x23
; 0000 005D                 {
; 0000 005E                     inputPass[passIndex] = k + 0x30;
	RCALL SUBOPT_0x4
	MOV  R30,R19
	RCALL SUBOPT_0x9
; 0000 005F                     passIndex++;
; 0000 0060                     lcd_gotoxy(4+passIndex,1);
; 0000 0061                     lcd_putchar('*');
; 0000 0062                 }
; 0000 0063             }
_0x23:
_0x1F:
_0x10:
; 0000 0064         }
	RJMP _0x4
; 0000 0065 }
_0x24:
	RJMP _0x24
; .FEND

	.DSEG
_0x7:
	.BYTE 0x11
;
;char GetKey()
; 0000 0068 {

	.CSEG
_GetKey:
; .FSTART _GetKey
; 0000 0069     unsigned char key = 16;
; 0000 006A     unsigned char row;
; 0000 006B 
; 0000 006C //D ROW
; 0000 006D     PORTD.7 = 0;
	RCALL __SAVELOCR2
;	key -> R17
;	row -> R16
	LDI  R17,16
	CBI  0x12,7
; 0000 006E     row = PIND & 0x07;
	RCALL SUBOPT_0xA
; 0000 006F     if(row != 0x07)
	BREQ _0x27
; 0000 0070     {
; 0000 0071         switch(row)
	RCALL SUBOPT_0xB
; 0000 0072         {
; 0000 0073             case 0b110 : key = 11; break;
	BRNE _0x2B
	LDI  R17,LOW(11)
	RJMP _0x2A
; 0000 0074             case 0b101 : key = 0; break;
_0x2B:
	RCALL SUBOPT_0xC
	BRNE _0x2C
	LDI  R17,LOW(0)
	RJMP _0x2A
; 0000 0075             case 0b011 : key = 10; break;
_0x2C:
	RCALL SUBOPT_0xD
	BRNE _0x2A
	LDI  R17,LOW(10)
; 0000 0076         }
_0x2A:
; 0000 0077     }
; 0000 0078     PORTD.7 = 1;
_0x27:
	SBI  0x12,7
; 0000 0079 
; 0000 007A 
; 0000 007B //C ROW
; 0000 007C     PORTD.6 = 0;
	CBI  0x12,6
; 0000 007D     row = PIND & 0x07;
	RCALL SUBOPT_0xA
; 0000 007E     if(row != 0x07)
	BREQ _0x32
; 0000 007F     {
; 0000 0080         switch(row)
	RCALL SUBOPT_0xB
; 0000 0081         {
; 0000 0082             case 0b110 : key = 9; break;
	BRNE _0x36
	LDI  R17,LOW(9)
	RJMP _0x35
; 0000 0083             case 0b101 : key = 8; break;
_0x36:
	RCALL SUBOPT_0xC
	BRNE _0x37
	LDI  R17,LOW(8)
	RJMP _0x35
; 0000 0084             case 0b011 : key = 7; break;
_0x37:
	RCALL SUBOPT_0xD
	BRNE _0x35
	LDI  R17,LOW(7)
; 0000 0085         }
_0x35:
; 0000 0086     }
; 0000 0087     PORTD.6 = 1;
_0x32:
	SBI  0x12,6
; 0000 0088 
; 0000 0089 
; 0000 008A 
; 0000 008B //B ROW
; 0000 008C     PORTD.5 = 0;
	CBI  0x12,5
; 0000 008D     row = PIND & 0x7;
	RCALL SUBOPT_0xA
; 0000 008E     if(row != 0x07)
	BREQ _0x3D
; 0000 008F     {
; 0000 0090         switch(row)
	RCALL SUBOPT_0xB
; 0000 0091         {
; 0000 0092             case 0b110 : key = 6; break;
	BRNE _0x41
	LDI  R17,LOW(6)
	RJMP _0x40
; 0000 0093             case 0b101 : key = 5; break;
_0x41:
	RCALL SUBOPT_0xC
	BRNE _0x42
	LDI  R17,LOW(5)
	RJMP _0x40
; 0000 0094             case 0b011 : key = 4; break;
_0x42:
	RCALL SUBOPT_0xD
	BRNE _0x40
	LDI  R17,LOW(4)
; 0000 0095         }
_0x40:
; 0000 0096     }
; 0000 0097     PORTD.5 = 1;
_0x3D:
	SBI  0x12,5
; 0000 0098 
; 0000 0099 
; 0000 009A 
; 0000 009B //A ROW
; 0000 009C     PORTD.4 = 0;
	CBI  0x12,4
; 0000 009D     row = PIND & 0x07;
	RCALL SUBOPT_0xA
; 0000 009E     if(row != 0x07)
	BREQ _0x48
; 0000 009F     {
; 0000 00A0         switch(row)
	RCALL SUBOPT_0xB
; 0000 00A1         {
; 0000 00A2             case 0b110 : key = 3; break;
	BRNE _0x4C
	LDI  R17,LOW(3)
	RJMP _0x4B
; 0000 00A3             case 0b101 : key = 2; break;
_0x4C:
	RCALL SUBOPT_0xC
	BRNE _0x4D
	LDI  R17,LOW(2)
	RJMP _0x4B
; 0000 00A4             case 0b011 : key = 1; break;
_0x4D:
	RCALL SUBOPT_0xD
	BRNE _0x4B
	LDI  R17,LOW(1)
; 0000 00A5         }
_0x4B:
; 0000 00A6     }
; 0000 00A7     PORTD.4 = 1;
_0x48:
	SBI  0x12,4
; 0000 00A8 
; 0000 00A9      if(key != 16)
	CPI  R17,16
	BREQ _0x51
; 0000 00AA      {
; 0000 00AB         delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0xE
; 0000 00AC      }
; 0000 00AD     PORTD = 0xFF;
_0x51:
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00AE     return key;
	MOV  R30,R17
	RJMP _0x20A0003
; 0000 00AF }
; .FEND
;
;void changePass()
; 0000 00B2 {
_changePass:
; .FSTART _changePass
; 0000 00B3 
; 0000 00B4 //Needed variables
; 0000 00B5     char inputPass[6] = "";
; 0000 00B6     char passIndex = 0;
; 0000 00B7 
; 0000 00B8     char newPass[6]= "";
; 0000 00B9     char newPassIndex = 0;
; 0000 00BA 
; 0000 00BB     char ReNewPass[6]= "";
; 0000 00BC     char ReNewPassIndex = 0;
; 0000 00BD 
; 0000 00BE     char k;
; 0000 00BF 
; 0000 00C0 //stage 1 (current password)
; 0000 00C1 
; 0000 00C2     lcd_clear();
	SBIW R28,18
	LDI  R24,18
	RCALL SUBOPT_0xF
	LDI  R30,LOW(_0x52*2)
	LDI  R31,HIGH(_0x52*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR4
;	inputPass -> Y+16
;	passIndex -> R17
;	newPass -> Y+10
;	newPassIndex -> R16
;	ReNewPass -> Y+4
;	ReNewPassIndex -> R19
;	k -> R18
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	RCALL _lcd_clear
; 0000 00C3 
; 0000 00C4     while(1)
_0x53:
; 0000 00C5     {
; 0000 00C6         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
; 0000 00C7         lcd_putsf("--current pass--");
	__POINTW2FN _0x0,51
	RCALL _lcd_putsf
; 0000 00C8 
; 0000 00C9         while(1)
_0x56:
; 0000 00CA         {
; 0000 00CB             k = GetKey();
	RCALL SUBOPT_0x10
; 0000 00CC             if(k != 16) break;
	BREQ _0x56
; 0000 00CD         }
; 0000 00CE 
; 0000 00CF         if(k == 10)
	CPI  R18,10
	BRNE _0x5A
; 0000 00D0         {
; 0000 00D1             while(GetKey() != 16);
_0x5B:
	RCALL SUBOPT_0x1
	BRNE _0x5B
; 0000 00D2             strcpyf(inputPass,"");
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x3
; 0000 00D3             passIndex = 0;
; 0000 00D4         }
; 0000 00D5         else if(k == 11)
	RJMP _0x5E
_0x5A:
	CPI  R18,11
	BRNE _0x5F
; 0000 00D6         {
; 0000 00D7             while(GetKey() != 16);
_0x60:
	RCALL SUBOPT_0x1
	BRNE _0x60
; 0000 00D8             inputPass[passIndex] = '\0';
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x5
; 0000 00D9 
; 0000 00DA             if(strcmp(inputPass, Password) == 0)
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x6
	BREQ _0x55
; 0000 00DB                 break;
; 0000 00DC 
; 0000 00DD             else
; 0000 00DE             {
; 0000 00DF                 lcd_clear();
	RCALL SUBOPT_0x7
; 0000 00E0                 lcd_gotoxy(0,0);
; 0000 00E1                 lcd_putsf("-----WRONG------");
	RCALL SUBOPT_0x8
; 0000 00E2                 delay_ms(2000);
; 0000 00E3 
; 0000 00E4             }
; 0000 00E5             strcpyf(inputPass, "");
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x3
; 0000 00E6             passIndex = 0;
; 0000 00E7         }
; 0000 00E8         else
	RJMP _0x65
_0x5F:
; 0000 00E9         {
; 0000 00EA             while(GetKey()!= 16);
_0x66:
	RCALL SUBOPT_0x1
	BRNE _0x66
; 0000 00EB 
; 0000 00EC             if(passIndex < sizeof(inputPass) - 1)
	CPI  R17,5
	BRSH _0x69
; 0000 00ED             {
; 0000 00EE                 inputPass[passIndex] = k + 0x30;
	RCALL SUBOPT_0x12
	MOV  R30,R18
	RCALL SUBOPT_0x9
; 0000 00EF                 passIndex++;
; 0000 00F0                 lcd_gotoxy(4+passIndex,1);
; 0000 00F1                 lcd_putchar('*');
; 0000 00F2             }
; 0000 00F3         }
_0x69:
_0x65:
_0x5E:
; 0000 00F4     }
	RJMP _0x53
_0x55:
; 0000 00F5 
; 0000 00F6 //stage 2 (new pass)
; 0000 00F7 
; 0000 00F8     lcd_clear();
	RCALL _lcd_clear
; 0000 00F9     while(1)
_0x6A:
; 0000 00FA     {
; 0000 00FB         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
; 0000 00FC         lcd_putsf("----New Pass----");
	__POINTW2FN _0x0,68
	RCALL _lcd_putsf
; 0000 00FD         while(1)
_0x6D:
; 0000 00FE         {
; 0000 00FF             k = GetKey();
	RCALL SUBOPT_0x10
; 0000 0100             if(k != 16) break;
	BREQ _0x6D
; 0000 0101         }
; 0000 0102 
; 0000 0103         if(k == 10)
	CPI  R18,10
	BRNE _0x71
; 0000 0104         {
; 0000 0105             while(GetKey() != 16);
_0x72:
	RCALL SUBOPT_0x1
	BRNE _0x72
; 0000 0106 
; 0000 0107             strcpyf(newPass,"");
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x3
; 0000 0108             passIndex = 0;
; 0000 0109         }
; 0000 010A         else if(k == 11)
	RJMP _0x75
_0x71:
	CPI  R18,11
	BRNE _0x76
; 0000 010B         {
; 0000 010C             while(GetKey() != 16);
_0x77:
	RCALL SUBOPT_0x1
	BRNE _0x77
; 0000 010D             newPass[passIndex] = '\0';
	MOV  R30,R17
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x5
; 0000 010E 
; 0000 010F             if(newPassIndex == 5)
	CPI  R16,5
	BREQ _0x6C
; 0000 0110                 break;
; 0000 0111             else
; 0000 0112             {
; 0000 0113                 lcd_clear();
	RCALL SUBOPT_0x7
; 0000 0114                 lcd_gotoxy(0,0);
; 0000 0115                 lcd_putsf("-Enter 5 Digits-");
	__POINTW2FN _0x0,85
	RCALL _lcd_putsf
; 0000 0116                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0117             }
; 0000 0118         }
; 0000 0119         else
	RJMP _0x7C
_0x76:
; 0000 011A         {
; 0000 011B             while(GetKey()!= 16);
_0x7D:
	RCALL SUBOPT_0x1
	BRNE _0x7D
; 0000 011C 
; 0000 011D             if(newPassIndex < sizeof(newPass) - 1)
	CPI  R16,5
	BRSH _0x80
; 0000 011E             {
; 0000 011F                 newPass[newPassIndex] = k + 0x30;
	MOV  R30,R16
	RCALL SUBOPT_0x14
	MOV  R30,R18
	SUBI R30,-LOW(48)
	ST   X,R30
; 0000 0120                 newPassIndex++;
	SUBI R16,-1
; 0000 0121                 lcd_gotoxy(4+newPassIndex,1);
	MOV  R30,R16
	RCALL SUBOPT_0x15
; 0000 0122                 lcd_putchar(k + 0x30);
; 0000 0123             }
; 0000 0124         }
_0x80:
_0x7C:
_0x75:
; 0000 0125     }
	RJMP _0x6A
_0x6C:
; 0000 0126 
; 0000 0127 
; 0000 0128 //stage 3 (repeat new pass)
; 0000 0129     lcd_clear();
	RCALL _lcd_clear
; 0000 012A 
; 0000 012B     while(1)
_0x81:
; 0000 012C     {
; 0000 012D         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
; 0000 012E         lcd_putsf("REenter new pass");
	__POINTW2FN _0x0,102
	RCALL _lcd_putsf
; 0000 012F         while(1)
_0x84:
; 0000 0130         {
; 0000 0131             k = GetKey();
	RCALL SUBOPT_0x10
; 0000 0132             if(k != 16) break;
	BREQ _0x84
; 0000 0133         }
; 0000 0134 
; 0000 0135         if(k == 10)
	CPI  R18,10
	BRNE _0x88
; 0000 0136         {
; 0000 0137             while(GetKey() != 16);
_0x89:
	RCALL SUBOPT_0x1
	BRNE _0x89
; 0000 0138 
; 0000 0139             strcpyf(ReNewPass,"");
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
; 0000 013A             ReNewPassIndex = 0;
; 0000 013B         }
; 0000 013C         else if(k == 11)
	RJMP _0x8C
_0x88:
	CPI  R18,11
	BRNE _0x8D
; 0000 013D         {
; 0000 013E             while(GetKey() != 16);
_0x8E:
	RCALL SUBOPT_0x1
	BRNE _0x8E
; 0000 013F 
; 0000 0140             ReNewPass[ReNewPassIndex] = '\0';
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x5
; 0000 0141 
; 0000 0142             if(strcmp(ReNewPass, newPass) == 0)
	RCALL SUBOPT_0x16
	MOVW R26,R28
	ADIW R26,12
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x91
; 0000 0143             {
; 0000 0144                 strcpy(Password, newPass);
	LDI  R30,LOW(_Password)
	LDI  R31,HIGH(_Password)
	RCALL SUBOPT_0x13
	MOVW R26,R28
	ADIW R26,12
	RCALL _strcpy
; 0000 0145 
; 0000 0146                 //TODO: add to eeprom storage
; 0000 0147                 eeprom_write_byte(0, Password[0]);
	LDS  R30,_Password
	RCALL SUBOPT_0xF
	RCALL __EEPROMWRB
; 0000 0148                 eeprom_write_byte(1, Password[1]);
	__GETB1MN _Password,1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __EEPROMWRB
; 0000 0149                 eeprom_write_byte(2, Password[2]);
	__GETB1MN _Password,2
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	RCALL __EEPROMWRB
; 0000 014A                 eeprom_write_byte(3, Password[3]);
	__GETB1MN _Password,3
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __EEPROMWRB
; 0000 014B                 eeprom_write_byte(4, Password[4]);
	__GETB1MN _Password,4
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	RCALL __EEPROMWRB
; 0000 014C 
; 0000 014D                 lcd_clear();
	RCALL SUBOPT_0x7
; 0000 014E                 lcd_gotoxy(0,0);
; 0000 014F                 lcd_putsf("--Pass changed--");
	__POINTW2FN _0x0,119
	RCALL _lcd_putsf
; 0000 0150                 break;
	RJMP _0x83
; 0000 0151             }
; 0000 0152             else
_0x91:
; 0000 0153             {
; 0000 0154                 lcd_clear();
	RCALL SUBOPT_0x7
; 0000 0155                 lcd_gotoxy(0,0);
; 0000 0156                 lcd_putsf("-----WRONG------");
	RCALL SUBOPT_0x8
; 0000 0157                 delay_ms(2000);
; 0000 0158 
; 0000 0159             }
; 0000 015A             strcpyf(ReNewPass, "");
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
; 0000 015B             ReNewPassIndex = 0;
; 0000 015C         }
; 0000 015D         else
	RJMP _0x93
_0x8D:
; 0000 015E         {
; 0000 015F             while(GetKey()!= 16);
_0x94:
	RCALL SUBOPT_0x1
	BRNE _0x94
; 0000 0160 
; 0000 0161             if(ReNewPassIndex < sizeof(ReNewPass) - 1)
	CPI  R19,5
	BRSH _0x97
; 0000 0162             {
; 0000 0163                 ReNewPass[ReNewPassIndex] = k + 0x30;
	RCALL SUBOPT_0x18
	MOV  R30,R18
	SUBI R30,-LOW(48)
	ST   X,R30
; 0000 0164                 ReNewPassIndex++;
	SUBI R19,-1
; 0000 0165                 lcd_gotoxy(4 + ReNewPassIndex,1);
	MOV  R30,R19
	RCALL SUBOPT_0x15
; 0000 0166                 lcd_putchar(k + 0x30);
; 0000 0167             }
; 0000 0168         }
_0x97:
_0x93:
_0x8C:
; 0000 0169     }
	RJMP _0x81
_0x83:
; 0000 016A 
; 0000 016B 
; 0000 016C }
	RCALL __LOADLOCR4
	ADIW R28,22
	RET
; .FEND
;
;void checkPassFromEEPROM()
; 0000 016F {
_checkPassFromEEPROM:
; .FSTART _checkPassFromEEPROM
; 0000 0170     char emptyFlag = 1;
; 0000 0171 
; 0000 0172     //TODO: check if eeprom is empty or what?
; 0000 0173     char test = eeprom_read_byte(0);
; 0000 0174     if (test != 0xFF)
	RCALL __SAVELOCR2
;	emptyFlag -> R17
;	test -> R16
	LDI  R17,1
	RCALL SUBOPT_0xF
	RCALL __EEPROMRDB
	MOV  R16,R30
	CPI  R16,255
	BREQ _0x98
; 0000 0175     {
; 0000 0176         emptyFlag = 0;
	LDI  R17,LOW(0)
; 0000 0177     }
; 0000 0178 
; 0000 0179     //TODO: if eeprom is full cpy it to password
; 0000 017A     if(!emptyFlag)
_0x98:
	CPI  R17,0
	BRNE _0x99
; 0000 017B     {
; 0000 017C         Password[0] = eeprom_read_byte(0);
	RCALL SUBOPT_0xF
	RCALL __EEPROMRDB
	STS  _Password,R30
; 0000 017D         Password[1] = eeprom_read_byte(1);
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __EEPROMRDB
	__PUTB1MN _Password,1
; 0000 017E         Password[2] = eeprom_read_byte(2);
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	RCALL __EEPROMRDB
	__PUTB1MN _Password,2
; 0000 017F         Password[3] = eeprom_read_byte(3);
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __EEPROMRDB
	__PUTB1MN _Password,3
; 0000 0180         Password[4] = eeprom_read_byte(4);
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	RCALL __EEPROMRDB
	__PUTB1MN _Password,4
; 0000 0181     }
; 0000 0182 }
_0x99:
_0x20A0003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0x19
	SBI  0x18,2
	RCALL SUBOPT_0x19
	CBI  0x18,2
	RCALL SUBOPT_0x19
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xE
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20A0001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x20A0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x1A
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20A0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_strcmp:
; .FSTART _strcmp
	RCALL SUBOPT_0x1A
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	RCALL SUBOPT_0x1A
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x1A
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND

	.CSEG

	.CSEG

	.DSEG
_Password:
	.BYTE 0x6
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	RCALL _GetKey
	CPI  R30,LOW(0x10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	__POINTW2FN _0x0,16
	RCALL _strcpyf
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_Password)
	LDI  R27,HIGH(_Password)
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL _lcd_clear
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	__POINTW2FN _0x0,34
	RCALL _lcd_putsf
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	SUBI R30,-LOW(48)
	ST   X,R30
	SUBI R17,-1
	MOV  R30,R17
	SUBI R30,-LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	LDI  R26,LOW(42)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	IN   R30,0x10
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	CPI  R16,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	MOV  R30,R16
	LDI  R31,0
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	RCALL _GetKey
	MOV  R18,R30
	CPI  R18,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,16
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,10
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	SUBI R30,-LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	MOV  R26,R18
	SUBI R26,-LOW(48)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__POINTW2FN _0x0,16
	RCALL _strcpyf
	LDI  R19,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
