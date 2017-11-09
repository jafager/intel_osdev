section .text
bits32



global startup
startup:

    mov dword [0xb8000], 0x2f4b2f4f
    hlt
