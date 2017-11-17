%define serial_com1_data_port               0x3f8
%define serial_com1_fifo_command_port       0x3fa
%define serial_com1_line_command_port       0x3fb
%define serial_com1_modem_command_port      0x3fc
%define serial_com1_line_status_port        0x3fd




section .text
bits 32



global serial_init
serial_init:

    push eax
    push edx

    ; set divisor latch
    mov dx, serial_com1_line_command_port
    mov al, (1 << 7)
    out dx, al

    ; set 115,200 baud
    mov dx, serial_com1_data_port
    mov al, 0x00
    out dx, al
    mov al, 0x01 
    out dx, al

    ; disable divisor latch and set 8N1
    mov dx, serial_com1_line_command_port
    mov al, 0x03
    out dx, al

    ; configure FIFOs
    mov dx, serial_com1_fifo_command_port
    mov al, 0xc7
    out dx, al

    ; configure modem control
    mov dx, serial_com1_modem_command_port
    mov al, 0x03
    out dx, al

    pop edx
    pop eax
    ret



global serial_putc
serial_putc:

    push eax
    push edx

    ; wait for FIFO to be empty
    mov dx, serial_com1_line_status_port
    push eax
    .serial_putc_wait_for_empty:
        in al, dx
        test al, (1 << 5)
        je .serial_putc_wait_for_empty

    ; send byte
    mov dx, serial_com1_data_port
    pop eax
    out dx, al

    pop edx
    pop eax
    ret



global serial_puts
serial_puts:

    push eax
    push edx

    mov edx, eax

    .serial_puts_next_character:

        mov al, [edx]
        cmp al, 0
        je .serial_puts_end_of_string

        call serial_putc
        inc edx
        jmp .serial_puts_next_character

    .serial_puts_end_of_string:

    pop edx
    pop eax
    ret
