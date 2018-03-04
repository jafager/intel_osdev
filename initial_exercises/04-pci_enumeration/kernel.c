#include "console.h"
#include "pci.h"



void kernel(void)
{

    console_init();

    for (uint32_t bus = 0; bus < 256; bus++)
        for (uint32_t slot = 0; slot < 32; slot++)
        {
            uint16_t vendor_id = pci_get_vendor_id(bus, slot);
            if (vendor_id != 0xffff)
            {
                console_hexprint(vendor_id);
                console_puts(" ");
                console_hexprint(pci_get_device_id(bus, slot));
                console_puts("\r\n");
            }
        }

    console_puts("Done.\r\n");

}
