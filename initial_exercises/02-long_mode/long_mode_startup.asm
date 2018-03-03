section .text
bits 64



extern serial_puts



global long_mode_startup
long_mode_startup:

    ;mov rax, .message_ready
    ;call serial_puts

    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax
    hlt



.message_ready:

    db `Ready.\r\n\0`
