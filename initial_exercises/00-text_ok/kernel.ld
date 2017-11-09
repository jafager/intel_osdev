ENTRY(startup)

MEMORY
{
    ram : ORIGIN = 0x00100000, LENGTH = 0x00300000
}

SECTIONS
{
    .boot : { *(.multiboot_header) } > ram
    .text : { *(.text*) } > ram
    .data : { *(.data*) } > ram

    bss_begin = .;
        .bss : { *(.bss*) } > ram
    bss_end = .;

    stack_bottom = .;
        . = . + 0x1000;
    stack_top = .;
}
