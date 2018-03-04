all: iso

iso: kernel.iso

kernel.iso: kernel.elf iso/boot/grub/grub.cfg
	cp kernel.elf iso/boot/kernel.elf
	grub-mkrescue -o kernel.iso iso

kernel.elf: kernel.ld multiboot_header.o startup.o kernel.o console.o serial.o port.o reg.o pci.o
	x86_64-elf-ld -melf_i386 -n -o $@ -T $^

%.o: %.c
	x86_64-elf-gcc -m32 -c -o $@ $^

%.o: %.asm
	nasm -g -f elf32 -o $@ $^

run: kernel.iso
	qemu-system-x86_64 -cdrom kernel.iso -serial stdio

monitor: kernel.iso
	qemu-system-x86_64 -cdrom kernel.iso -monitor stdio

dump: kernel.elf
	x86_64-elf-objdump -M intel -d kernel.elf

clean:
	rm -f *.iso *.elf *.o iso/boot/kernel.elf
