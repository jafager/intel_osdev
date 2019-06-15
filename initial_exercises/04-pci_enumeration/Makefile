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

runvirtio:
	qemu-system-x86_64 -cdrom kernel.iso -serial stdio -device virtio-serial-pci,max_ports=4 -device virtconsole,chardev=virtioserial -chardev file,id=virtioserial,path=virtioserial -device virtio-blk-pci,drive=virtiodrive -drive id=virtiodrive,file=virtiodrive,if=none,format=raw -net none -vga none -device virtio-blk-pci,drive=virtiodrive2 -drive id=virtiodrive2,file=virtiodrive2,if=none,format=raw

monitor: kernel.iso
	qemu-system-x86_64 -cdrom kernel.iso -monitor stdio

dump: kernel.elf
	x86_64-elf-objdump -M intel -d kernel.elf

clean:
	rm -f *.iso *.elf *.o iso/boot/kernel.elf
