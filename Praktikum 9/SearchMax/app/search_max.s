;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
				AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
				PUSH	{R4}
				
				; check if length = 0
				CMP		R1, #0
				BNE		calc_max
				
				LDR		R2, =0x80000000
				B 		return
				
				; init max to 0, index to 0
calc_max		LDR		R2, [R0]
				MOVS	R3, #0
				LSLS	R1,R1,#2

				; add 1 to index and check if end is reached
loop			ADDS	R3, #4
				CMP		R1, R3
				BLS		return
				
				; compare max with next value in table
				LDR		R4, [R0, R3]
				CMP		R4, R2
				BLE		loop
				
				; if value is bigger, save new max value
				MOV		R2, R4
				B		loop

			
				; Move max from R2 to R0 and return
return			MOV		R0, R2
				POP		{R4}
				BX		LR
				
                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

