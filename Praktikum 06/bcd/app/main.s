; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_7_0           	EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
	
ADDR_SEG_1_2			EQU		0x60000114
ADDR_SEG_3_4			EQU		0x60000115
	
ADDR_BUTTONS            EQU     0x60000210
BTN_MASK				EQU		0x01

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY
		
main    PROC
        export main
			
		MOVS	R0, #0
       
; STUDENTS: To be programmed

main_loop
		BL pause
		
		; Read BCD Ones
		LDR 	R4, =ADDR_DIP_SWITCH_7_0
		LDRB	R4, [R4]
		
		; Read BCD Tens
		LDR		R1, =ADDR_DIP_SWITCH_15_8
		LDRB	R1, [R1]
		
		; Read Button Press
		LDR		R3, =ADDR_BUTTONS
		LDRB	R3, [R3]
		
		; Combine BCD codes
		LSLS	R2, R1, #4
		ORRS	R2, R2, R4
		
		; Button Pressed ?
		MOVS	R7, #1
		TST		R3, R7
		BEQ		T0_Released
		
T0_Pressed
		; Calculate Binary Value
		MOVS	R6, R1
		LSLS	R1, R1, #3
		LSLS	R6, R6, #1
		ADDS	R1, R1, R6
		ADDS	R1, R1, R4
		
		; Set Display Color to red
		LDR		R6, =ADDR_LCD_RED
		LDR		R7, =LCD_BACKLIGHT_FULL
		STRH	R7, [R6]
		
		LDR		R6, =ADDR_LCD_BLUE
		LDR		R7, =LCD_BACKLIGHT_OFF
		STRH	R7, [R6]
		
		B		T0_END

T0_Released
		; Calculate Binary Value
		MOVS	R6, #10
		MULS	R1, R6, R1
		ADDS	R1, R1, R4
		
		; Set Display Color to blue
		LDR		R6, =ADDR_LCD_RED
		LDR		R7, =LCD_BACKLIGHT_OFF
		STRH	R7, [R6]
		
		LDR		R6, =ADDR_LCD_BLUE
		LDR		R7, =LCD_BACKLIGHT_FULL
		STRH	R7, [R6]

T0_END
		; Sum up all On Leds
		MOVS	R7, #1
		MOVS	R5, #0
		MOVS	R4, #0
		
loop1
		MOVS 	R6, R1			; get Input
		LSRS	R6, R6, R4		; shift right by R4
		ANDS	R6, R6, R7		; mask bit0
		
		LSLS	R5, R5, R6		; Shift 'Ones' from right
		ADDS	R5, R5, R6		
		
		ADDS	R4, R4, #1		; increment shift
		CMP		R4, #8			; check if shifted 7 times
		BNE		loop1
		
		; Rotate 
		ADDS	R0, #1			; Calc Rotation Position (0-15)
		LSLS	R0, R0, #28
		LSRS	R0, R0, #28
		
		LSLS	R6, R5, #16		; Set LED to position
		ORRS	R5, R5, R6
		RORS	R5, R5, R0
		
		; Display LED Bar
		LDR		R7, =ADDR_LED_31_16
		STRH	R5, [R7]
		

		; Display BCD code
		LDR		R3, =ADDR_LED_7_0
		STRB	R2, [R3]
		
		LDR		R3, =ADDR_SEG_1_2
		STRB	R2, [R3]
		
		; Display Binary Value
		LDR		R3, =ADDR_LED_15_8
		STRB	R1, [R3]
		
		LDR		R3, =ADDR_SEG_3_4
		STRB	R1, [R3]



; END: To be programmed

        B       main_loop
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
