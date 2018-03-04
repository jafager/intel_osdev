#include "stdint.h"
#include "port.h"
#include "pci.h"



uint32_t pci_read_configuration_space(uint32_t bus, uint32_t slot, uint32_t function, uint32_t offset)
{

    uint32_t address = 0;
    address |= (1 << 31);
    address |= ((bus & 0b11111111) << 16);
    address |= ((slot & 0b11111) << 11);
    address |= ((function & 0b111) << 8);
    address |= (offset & 0b11111100);

    portwrite32(PCI_CONFIG_ADDRESS, address);
    return portread32(PCI_CONFIG_DATA);

}



uint16_t pci_get_device_id(uint32_t bus, uint32_t slot)
{
    uint32_t data = pci_read_configuration_space(bus, slot, 0, 0x00);
    return (uint16_t)(data >> 16);
}



uint16_t pci_get_vendor_id(uint32_t bus, uint32_t slot)
{
    uint32_t data = pci_read_configuration_space(bus, slot, 0, 0x00);
    return (uint16_t)(data & 0xffff);
}
