#ifndef PCI_H
#define PCI_H



#include "stdint.h"



#define PCI_CONFIG_ADDRESS      0xcf8
#define PCI_CONFIG_DATA         0xcfc



uint32_t pci_read_configuration_space(uint32_t bus, uint32_t slot, uint32_t function, uint32_t offset);
uint16_t pci_get_device_id(uint32_t bus, uint32_t slot);
uint16_t pci_get_vendor_id(uint32_t bus, uint32_t slot);



#endif /* PCI_H */
