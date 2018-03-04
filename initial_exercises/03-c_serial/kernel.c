#include "serial.h"



void kernel(void)
{

    serial_init(SERIAL0);
    serial_puts(SERIAL0, "Ready.\n");

}
