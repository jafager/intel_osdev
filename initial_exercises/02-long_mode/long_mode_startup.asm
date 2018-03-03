section .text
bits 64



extern serial_puts_64



global long_mode_startup
long_mode_startup:

    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax

    mov rax, .message_long_mode_ready
    call serial_puts_64

    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax
    hlt



.message_long_mode_ready:

    db `Long mode ready.\r\n\0`
