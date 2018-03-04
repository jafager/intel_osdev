#include "stdint.h"
#include "port.h"
#include "serial.h"



void serial_init(uint16_t base_address)
{
    // set divisor latch
    portwrite8(base_address + SERIAL_LINE_COMMAND_PORT, 1 << 7);

    // set 115,200 baud
    portwrite8(base_address + SERIAL_DATA_PORT, 0x00);
    portwrite8(base_address + SERIAL_DATA_PORT, 0x01);

    // disable divisor latch and set 8N1
    portwrite8(base_address + SERIAL_LINE_COMMAND_PORT, 0x03);

    // configure FIFOs
    portwrite8(base_address + SERIAL_FIFO_COMMAND_PORT, 0xc7);

    // configure modem control
    portwrite8(base_address + SERIAL_MODEM_COMMAND_PORT, 0x03);
}



void serial_putc(uint16_t base_address, uint8_t character)
{
    // wait for FIFO to be empty
    while (!(portread8(base_address + SERIAL_LINE_STATUS_PORT) & (1 << 5)));

    // send byte
    portwrite8(base_address + SERIAL_DATA_PORT, character);
}



void serial_puts(uint16_t base_address, uint8_t *string)
{
    uint8_t *character = string;
    while (*character)
        serial_putc(base_address, *character++);
}
