/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed




/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;

    // add variables below
    /// STUDENTS: To be programmed

		uint8_t counter_a = 0;
		uint8_t counter_c = 0;
	
		uint8_t btn_value = 0;
		uint8_t btn_old_value = 0;
		uint8_t btn_rising_edge = 0;
	
		uint8_t gp_var = 0;

    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);

        /// STUDENTS: To be programmed

				led_value &= 0x0F;
				led_value |= (1 << 7) | (1 << 6);


        /// END: To be programmed

        write_byte(ADDR_LED_7_0, led_value);

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed

				// read buttons
				btn_value = read_byte(ADDR_BUTTONS);
			
				// count buttons presses on T0 3.2 a)
				if(btn_value & 0x01)
					counter_a++;
				
				// print values to leds 15 .. 8
				write_byte(ADDR_LED_15_8, counter_a);

				// detect rising edges
				btn_rising_edge = ~btn_old_value & btn_value;
				btn_old_value = btn_value;
				
				// count buttons presses on T0
				if(btn_rising_edge & 0x01)
					counter_c++;
				
				// write counter value to leds 31 .. 24
				write_byte(ADDR_LED_31_24, counter_c);
				
				// Buttons Actions
				if(btn_rising_edge & 0x01)
						gp_var = read_byte(ADDR_DIP_SWITCH_7_0);
				else if(btn_rising_edge & 0x02)
						gp_var = gp_var ^ 0x3C;
				else if(btn_rising_edge & 0x04)
						gp_var = gp_var << 1;
				else if(btn_rising_edge & 0x08)
						gp_var = gp_var >> 1;
				
				// Print variable
				write_byte(ADDR_LED_23_16, gp_var);

        /// END: To be programmed
    }
}
