%define multiboot_magic_number  0x36d76289



section .text
bits 32



extern stack_top
extern kernel



global startup
startup:

    ; set up the stack
    mov esp, stack_top

    ; check multiboot magic number (the bootloader passes it via eax)
    cmp eax, multiboot_magic_number
    je .multiboot_magic_number_ok
    hlt
    .multiboot_magic_number_ok:

    ; jump to kernel
    call kernel

    ; hang the processor safely
    hlt
