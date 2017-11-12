section .text
bits 32



extern stack_top
extern serial_init
extern serial_puts



global startup
startup:

    ; set up the stack
    mov esp, stack_top

    ; initialize the serial port
    call serial_init

    ; write the ready message to the serial port
    mov eax, message_ready
    call serial_puts

    ; put the OK message on the screen
    mov dword [0xb8000], 0x2f4b2f4f

    ; hang the processor
    hlt



message_ready:

    db `Ready.\r\n\0`
