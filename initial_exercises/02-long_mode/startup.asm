%define multiboot_magic_number  0x36d76289



section .text
bits 32



extern stack_top
extern serial_init
extern serial_puts
extern l4_page_table_begin
extern l4_page_table_end
extern l3_page_table_begin
extern l3_page_table_end
extern l2_page_table_begin
extern l2_page_table_end
extern long_mode_startup



global startup
startup:

    ; set up the stack
    mov esp, stack_top

    ; initialize the serial port
    call serial_init

    ; check multiboot magic number (the bootloader passes it via eax)
    cmp eax, multiboot_magic_number
    je .multiboot_magic_number_ok
    mov eax, .message_bad_multiboot_magic_number
    call serial_puts
    hlt
    .multiboot_magic_number_ok:
    mov eax, .message_multiboot_magic_number_ok
    call serial_puts

    ; check if cpuid instruction is supported
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    cmp eax, ecx
    jne .cpuid_is_supported
    mov eax, .message_cpuid_is_not_supported
    call serial_puts
    hlt
    .cpuid_is_supported:
    mov eax, .message_cpuid_is_supported
    call serial_puts

    ; check if extended processor info is available
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jnb .extended_processor_info_is_available
    mov eax, .message_extended_processor_info_is_not_available
    call serial_puts
    hlt
    .extended_processor_info_is_available:
    mov eax, .message_extended_processor_info_is_available
    call serial_puts

    ; check if long mode is available
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jnz .long_mode_is_available
    mov eax, .message_long_mode_is_not_available
    call serial_puts
    hlt
    .long_mode_is_available:
    mov eax, .message_long_mode_is_available
    call serial_puts

    ; initialize l4 page table
    mov eax, l4_page_table_begin
    .next_l4_page_table_entry:
    mov dword [eax], 0
    add eax, 4
    cmp eax, l4_page_table_end
    jl .next_l4_page_table_entry

    ; initialize l3 page table
    mov eax, l3_page_table_begin
    .next_l3_page_table_entry:
    mov dword [eax], 0
    add eax, 4
    cmp eax, l3_page_table_end
    jl .next_l3_page_table_entry

    ; initialize l2 page table
    mov eax, l2_page_table_begin
    .next_l2_page_table_entry:
    mov dword [eax], 0
    add eax, 4
    cmp eax, l2_page_table_end
    jl .next_l2_page_table_entry

    ; set up identity paging for l2 page table
    mov eax, l2_page_table_begin
    mov edx, 0b10000011
    .next_l2_page_table_map:
    mov dword [eax], edx
    add eax, 8
    add edx, 0x200000
    cmp eax, l2_page_table_end
    jl .next_l2_page_table_map

    ; point first entry in l4 page table to the l3 page table
    mov eax, l3_page_table_begin
    or eax, 0b11
    mov [l4_page_table_begin], eax

    ; point first entry in l3 page table to the l2 page table
    mov eax, l2_page_table_begin
    or eax, 0b11
    mov [l3_page_table_begin], eax

    ; point MMU to l4 page table
    mov eax, l4_page_table_begin
    mov cr3, eax

    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; enable long mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    mov eax, .message_paging_enabled
    call serial_puts

    ; load the global descriptor table
    lgdt [global_descriptor_table.pointer]
    mov eax, .message_global_descriptor_table_loaded
    call serial_puts

    ; far jump into 64-bit long mode
    jmp global_descriptor_table.code:long_mode_startup



.message_bad_multiboot_magic_number:

    db `Bad multiboot magic number!\r\n\0`

.message_multiboot_magic_number_ok:

    db `Multiboot magic number OK.\r\n\0`

.message_cpuid_is_not_supported:

    db `CPUID instruction is not supported!\r\n\0`

.message_cpuid_is_supported:

    db `CPUID instruction is supported.\r\n\0`

.message_extended_processor_info_is_not_available:

    db `Extended processor info is not available!\r\n\0`

.message_extended_processor_info_is_available:

    db `Extended processor info is available.\r\n\0`

.message_long_mode_is_not_available:

    db `Long mode is not available!\r\n\0`

.message_long_mode_is_available:

    db `Long mode is available.\r\n\0`

.message_paging_enabled:

    db `Paging enabled.\r\n\0`

.message_global_descriptor_table_loaded:

    db `Global descriptor table loaded.\r\n\0`



global_descriptor_table:

    dq 0

    .code:
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)

    .pointer:
    dw $ - global_descriptor_table - 1
    dq global_descriptor_table
