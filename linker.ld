/* linker.ld */
ENTRY(kernel_entry)

SECTIONS
{
    . = 0x1000; /* Starting address for the kernel */
    .text : {
        *(.text)
        *(.text.*)
    }
    .data : {
        *(.data)
        *(.data.*)
    }
    .bss : {
        *(.bss)
        *(.bss.*)
    }
}
