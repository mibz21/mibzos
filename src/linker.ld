/* Linker script for RISC-V kernel */

OUTPUT_ARCH(riscv)
ENTRY(_start)

/* Memory layout for QEMU virt machine */
MEMORY
{
    /* RAM starts at 0x80000000 on QEMU virt machine */
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
    /* Set the location counter to the start of RAM */
    . = 0x80000000;

    /* Code section */
    .text : {
        *(.text.boot)    /* Boot code goes first */
        *(.text .text.*) /* Then all other code */
    } > RAM

    /* Read-only data */
    .rodata : {
        *(.rodata .rodata.*)
    } > RAM

    /* Initialized data */
    .data : {
        *(.data .data.*)
    } > RAM

    /* Uninitialized data (BSS) */
    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > RAM

    /* Stack (grows downward) */
    . = ALIGN(16);
    __stack_bottom = .;
    . = . + 0x10000; /* 64KB stack */
    __stack_top = .;

    /* Kernel end marker */
    __kernel_end = .;
}
