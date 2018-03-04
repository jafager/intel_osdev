#ifndef SERIAL_H
#define SERIAL_H



#include "stdint.h"



#define SERIAL0                     0x3f8
#define SERIAL1                     0x2f8

#define SERIAL_DATA_PORT            0x00
#define SERIAL_FIFO_COMMAND_PORT    0x02
#define SERIAL_LINE_COMMAND_PORT    0x03
#define SERIAL_MODEM_COMMAND_PORT   0x04
#define SERIAL_LINE_STATUS_PORT     0x05



void serial_init(uint16_t base_address);
void serial_putc(uint16_t base_address, uint8_t character);
void serial_puts(uint16_t base_address, uint8_t *string);



#endif /* SERIAL_H */
