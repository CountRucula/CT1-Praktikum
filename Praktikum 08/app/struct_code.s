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
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed
		; read adc value
		BL 			adc_get_value
		
		; read buttons
		LDR			R1, =ADDR_BUTTONS
		LDRB		R1, [R1]
		
		; if(buttons & 0x01)
		MOVS		R2, #0x01
		TST			R1, R2
		BEQ			t0_released
		
t0_pressed
		
		B			case_green

t0_released
		; read dip switches
		LDR			R1, =ADDR_DIP_SWITCH_7_0
		LDRB		R1, [R1]
		
		; diff = dip - adc
		SUBS		R1, R1, R0
		
		; write diff to 7-seg
		LDR			R3, =ADDR_7_SEG_BIN_DS3_0
		STR			R1, [R3]
		
		BPL			case_blue
		B			case_red
		
case_green
		; write adc value to 7-seg
		LDR			R3, =ADDR_7_SEG_BIN_DS3_0
		STR			R0, [R3]
		
		; calculate led-bar		
		MOVS		R3, #1
		LSRS		R0, R0, #3
		B			test
loop	
		LSLS		R3, R3, #1
		ADDS		R3, #1
		
		SUBS		R0, #1
test
		BNE			loop
		
		; display led bar
		LDR			R4, =ADDR_LED_31_0
		STR			R3, [R4]
		
		; set lcd bg to green
		LDR			R7, =ADDR_LCD_COLOUR
		LDR			R6, =0xFFFF
		LDR			R5, =0x0000
		
		STRH		R5, [R7, #DISPLAY_COLOUR_RED]
		STRH		R6, [R7, #DISPLAY_COLOUR_GREEN]
		STRH		R5, [R7, #DISPLAY_COLOUR_BLUE]
		
		B 			case_end

case_blue		
		; set lcd bg to green
		LDR			R7, =ADDR_LCD_COLOUR
		LDR			R6, =0xFFFF
		LDR			R5, =0x0000
		
		STRH		R5, [R7, #DISPLAY_COLOUR_RED]
		STRH		R5, [R7, #DISPLAY_COLOUR_GREEN]
		STRH		R6, [R7, #DISPLAY_COLOUR_BLUE]
		
		B 			case_end

case_red		
		; set lcd bg to green
		LDR			R7, =ADDR_LCD_COLOUR
		LDR			R6, =0xFFFF
		LDR			R5, =0x0000
		
		STRH		R6, [R7, #DISPLAY_COLOUR_RED]
		STRH		R5, [R7, #DISPLAY_COLOUR_GREEN]
		STRH		R5, [R7, #DISPLAY_COLOUR_BLUE]
		
		B 			case_end

case_end


; END: To be programmed
        B          main_loop
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
