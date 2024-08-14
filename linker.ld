/* linker.ld */
ENTRY(kernel_main)

SECTIONS
{
  . = 0x1000;                  /* Set start address of kernel */
  .text : {
    *(.text)                   /* All .text sections from input files */
  }
  .data : {
    *(.data)                   /* All .data sections from input files */
  }
  .bss : {
    *(.bss)                    /* All .bss sections from input files */
  }
}
