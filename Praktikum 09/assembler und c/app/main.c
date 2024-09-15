#include <stdint.h>

extern void write(uint32_t address, uint32_t value);
extern uint32_t read(uint32_t address);

#define addr_dip	0x60000200
#define addr_led	0x60000100

int main(void)
{
	uint32_t value = 0;
	
	while(1)
	{
		value = read(addr_dip);
		write(addr_led, value);
	}
	
	return 0;
}