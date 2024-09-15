;* ----------------------------------------------------------------------------
;* --  _____       ______  _____                                              -
;* -- |_   _|     |  ____|/ ____|                                             -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems              -
;* --   | | | '_ \|  __|  \___ \   Zurich University of                       -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                           -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland               -
;* ----------------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 12
;* -- Description : Reading the User-Button as Interrupt source
;* -- 				 
;* -- $Id: main.s 5082 2020-05-14 13:56:07Z akdi $
;* -- 		
;* ----------------------------------------------------------------------------


                IMPORT init_measurement
                IMPORT clear_IRQ_EXTI0
                IMPORT clear_IRQ_TIM2

; -----------------------------------------------------------------------------
; -- Constants
; -----------------------------------------------------------------------------

                AREA myCode, CODE, READONLY

                THUMB

REG_GPIOA_IDR       EQU  0x40020010
LED_15_0            EQU  0x60000100
LED_16_31           EQU  0x60000102
REG_CT_7SEG         EQU  0x60000114
REG_SETENA0         EQU  0xe000e100
	


; -----------------------------------------------------------------------------
; -- Main
; -----------------------------------------------------------------------------             
main            PROC
                EXPORT main


                BL   init_measurement    

                ; Configure NVIC (enable interrupt channel)
                ; STUDENTS: To be programmed
				LDR	R0, =REG_SETENA0
				LDR R1, =0x10000040
				STR R1, [R0]
				


                ; END: To be programmed 

                ; Initialize variables
                ; STUDENTS: To be programmed	


				LDR 	R0, =REG_CT_7SEG
				LDR		R1, =N_IRQs
                ; END: To be programmed

loop
                ; Output counter on 7-seg
                ; STUDENTS: To be programmed
				
				; display irq's during 2 seconds
				LDRH	R2, [R1]
				STRH	R2, [R0]

                ; END: To be programmed

                B    loop

                ENDP

; -----------------------------------------------------------------------------
; Handler for EXTI0 interrupt
; -----------------------------------------------------------------------------
                 ; STUDENTS: To be programmed
EXTI0_IRQHandler PROC
				EXPORT EXTI0_IRQHandler
				
				PUSH 	{LR}
				
				; clear interrupt bit
				BL		clear_IRQ_EXTI0
				
				; increment counter
				LDR		R0, =CNT
				LDR 	R1, [R0]
				ADDS	R1, #1
				STR 	R1, [R0]
				

				
				POP 	{PC}				
				ENDP

                 ; END: To be programmed

 
; -----------------------------------------------------------------------------                   
; Handler for TIM2 interrupt
; -----------------------------------------------------------------------------
                ; STUDENTS: To be programmed
TIM2_IRQHandler PROC
				EXPORT TIM2_IRQHandler
				PUSH	{LR}
				
				; clear interrupt bit
				BL		clear_IRQ_TIM2
				
				; load counter
				LDR		R0, =CNT
				LDR 	R1, [R0]
				
				; store number of irq's in 2 seconds
				LDR		R2, =N_IRQs
				STR 	R1, [R2]
				
				; reset counter
				MOVS	R1, #0
				STR 	R1, [R0]
				
				; check if LED are on
				LDR		R0, =LED_16_31
				LDRH	R1, [R0]
				CMP		R1, #0
				BNE		LED_OFF
LED_ON
				; turn them on
				LDR		R1, =0xFFFF
				STRH	R1, [R0]
				B		return

LED_OFF
				; turn them off
				LDR		R1, =0x00
				STRH	R1, [R0]

return
				
				POP		{PC}
				ENDP

                ; END: To be programmed
                ALIGN

; -----------------------------------------------------------------------------
; -- Variables
; -----------------------------------------------------------------------------

                AREA myVars, DATA, READWRITE

                ; STUDENTS: To be programmed

CNT				DCD  0x0
N_IRQs			DCD  0x0


                ; END: To be programmed


; -----------------------------------------------------------------------------
; -- End of file
; -----------------------------------------------------------------------------
                END
