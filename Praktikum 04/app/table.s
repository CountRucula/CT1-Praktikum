; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210
	
ADDR_SEG_1_2				EQU		0x60000114
ADDR_SEG_3_4				EQU		0x60000115

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
BITMASK_HIGH_NIBBLE        	EQU     0xF0

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed
byte_array	space 	32



; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed
		
		; Read Input Index and Mask Lower Nibble
		LDR		R1, =ADDR_DIP_SWITCH_15_8
		LDRB	R1, [R1]					
		LDR		R7, =BITMASK_LOWER_NIBBLE	
		ANDS	R1, R1, R7
		
		; Write Input index to leds
		LDR		R3, =ADDR_LED_15_8	
		STRB	R1, [R3]
		
		; Read Input Values
		LDR		R2, =ADDR_DIP_SWITCH_7_0
		LDRB	R2, [R2]	

		; write input values to leds
		LDR		R3, =ADDR_LED_7_0
		STRB	R2, [R3]
		
		;get input adress in table
		LDR		R3, =byte_array
		LSLS	R4, R1, #8
		ADDS	R2, R2, R4
		
		; store input value in table
		LSLS	R1, R1, #1
		STRH	R2, [R3, R1]
		
		; read Output Index and mask it
		LDR		R1, =ADDR_DIP_SWITCH_31_24
		LDRB	R1, [R1]					
		ANDS	R1, R1, R7
		
		; write output index to leds
		LDR		R4, =ADDR_LED_31_24
		STRB	R1, [R4]
		
		; Load Output Value
		LSLS	R1, R1, #1
		LDRH	R4, [R3, R1]
		;LDRB	R4, [R3, R1]
		
		LDR		R5, =ADDR_LED_23_16
		LDR		R6, =ADDR_SEG_1_2
		
		; write output values to leds and 7-seg
		STRB	R4, [R5]
		STRH	R4, [R6]

; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
