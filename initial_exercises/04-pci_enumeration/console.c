#include "stdint.h"
#include "serial.h"
#include "console.h"



void console_init(void)
{
    serial_init(CONSOLE);
}



void console_puts(uint8_t *string)
{
    serial_puts(CONSOLE, string);
}



void console_putc(uint8_t character)
{
    serial_putc(CONSOLE, character);
}



void console_hexprint(uint32_t value)
{
    uint32_t bits = 32;
    while (bits > 0)
    {
        bits -= 4;
        uint32_t digit = ((value >> bits) & 0xf) + 48;
        if (digit > 57)
            digit += 39;
        console_putc(digit);
    }
}
