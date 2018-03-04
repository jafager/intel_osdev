%define multiboot_magic_number      0xe85250d6
%define multiboot_architecture      0
%define multiboot_header_length     multiboot_header_end - multiboot_header_begin
%define multiboot_checksum          0x100000000 - (multiboot_magic_number + multiboot_architecture + multiboot_header_length)
%define multiboot_end_tag_type      0
%define multiboot_end_tag_flags     0
%define multiboot_end_tag_length    multiboot_end_tag_end - multiboot_end_tag_begin



section .multiboot_header
align 4
bits 32



multiboot_header_begin:

    dd multiboot_magic_number
    dd multiboot_architecture
    dd multiboot_header_length
    dd multiboot_checksum

    multiboot_end_tag_begin:

        dw multiboot_end_tag_type
        dw multiboot_end_tag_flags
        dd multiboot_end_tag_length

    multiboot_end_tag_end:

multiboot_header_end:
