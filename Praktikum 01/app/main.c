#include "utils_ctboard.h"

#define SW_ADDR 	0x60000200
#define LED_ADDR 	0x60000100
#define ROT_ADDR 0x60000211
#define DS0_ADDR 0x60000110

static const uint8_t SEG[16] =
{
	~0x3F,		//0
	~0x06,		//1
	~0x5B,		//2
	~0x4F,		//3
	~0x66,		//4
	~0x6D,		//5
	~0xFD,		//6.
	~0x07,		//7
	~0x7F,		//8
	~0xEF,		//9.
	~0x77,		//A
	~0x7C,		//b
	~0x39,		//C
	~0x5E,		//d
	~0x79,		//E
	~0x71			//F
};

int main(void)
{
	while(1)
	{
		write_word(LED_ADDR, read_word(SW_ADDR));
		write_byte(DS0_ADDR, SEG[read_byte(ROT_ADDR) & 0x0F]);
	}
}