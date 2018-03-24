#ifndef PORT_H
#define PORT_H



uint8_t portread8(uint16_t address);
void portwrite8(uint16_t address, uint8_t value);
uint32_t portread32(uint16_t address);
void portwrite32(uint16_t address, uint32_t value);



#endif /* PORT_H */
