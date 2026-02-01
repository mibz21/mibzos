/*
 * boot.S - RISC-V kernel bootstrap code
 *
 * This is the first code that runs when QEMU loads our kernel.
 * It sets up the stack and jumps to the C kernel code.
 */

.section .text.boot
.global _start

_start:
    /* Disable interrupts */
    csrw mie, zero

    /*
     * QEMU may start multiple harts (hardware threads).
     * Only hart 0 should continue; others should halt.
     */
    csrr t0, mhartid      # Read hart ID into t0
    bnez t0, halt         # If not hart 0, go to halt

    /*
     * Set up stack pointer
     * The linker script defines __stack_top
     */
    la sp, __stack_top

    /*
     * Clear BSS section (uninitialized data)
     * The linker script defines __bss_start and __bss_end
     */
    la t0, __bss_start
    la t1, __bss_end
clear_bss:
    beq t0, t1, bss_done  # If t0 == t1, BSS is cleared
    sd zero, 0(t0)        # Store zero at address t0
    addi t0, t0, 8        # Move to next 8-byte word
    j clear_bss

bss_done:
    /*
     * Jump to C kernel_main function
     * We'll never return from here
     */
    call kernel_main

halt:
    /* If we somehow return, just loop forever */
    wfi                   # Wait for interrupt (low power)
    j halt

/*
 * Assembly explanation:
 *
 * csrr  - Control Status Register Read
 * csrw  - Control Status Register Write
 * mhartid - Machine Hart ID register
 * mie   - Machine Interrupt Enable register
 *
 * la    - Load Address (pseudo-instruction)
 * bnez  - Branch if Not Equal to Zero
 * beq   - Branch if Equal
 * addi  - Add Immediate
 * sd    - Store Doubleword (64-bit)
 * wfi   - Wait For Interrupt
 */
