/* linker.ld */
ENTRY(kernel_main)

SECTIONS {
    . = 0x1000; /* Start address of the kernel */

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}
