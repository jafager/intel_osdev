section .text
bits 32



global portread8
portread8:
    mov dx, [esp + 4]
    in al, dx
    ret



global portwrite8
portwrite8:
    mov al, [esp + 8]
    mov dx, [esp + 4]
    out dx, al
    ret
