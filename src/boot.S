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
 * trap_handler - Entry point for all interrupts and exceptions
 *
 * This code runs when an interrupt or exception occurs.
 * We need to:
 * 1. Save all registers (context switch)
 * 2. Call C handler
 * 3. Restore all registers
 * 4. Return from trap (mret instruction)
 */
.align 4                  # Trap handlers must be 4-byte aligned
.global trap_handler
trap_handler:
    /*
     * Save all caller-saved registers to stack
     *
     * In RISC-V, we must save all registers that might be modified.
     * We save them to the stack, which grows downward.
     *
     * Stack frame layout (each register is 8 bytes):
     * sp+0   : ra  (return address)
     * sp+8   : t0
     * sp+16  : t1
     * ... (all temporary and argument registers)
     */

    # Allocate stack space (32 registers * 8 bytes = 256 bytes)
    addi sp, sp, -256

    # Save all registers
    sd ra,   0(sp)
    sd t0,   8(sp)
    sd t1,  16(sp)
    sd t2,  24(sp)
    sd a0,  32(sp)
    sd a1,  40(sp)
    sd a2,  48(sp)
    sd a3,  56(sp)
    sd a4,  64(sp)
    sd a5,  72(sp)
    sd a6,  80(sp)
    sd a7,  88(sp)
    sd t3,  96(sp)
    sd t4, 104(sp)
    sd t5, 112(sp)
    sd t6, 120(sp)

    # Call C interrupt handler
    call handle_trap

    # Restore all registers
    ld ra,   0(sp)
    ld t0,   8(sp)
    ld t1,  16(sp)
    ld t2,  24(sp)
    ld a0,  32(sp)
    ld a1,  40(sp)
    ld a2,  48(sp)
    ld a3,  56(sp)
    ld a4,  64(sp)
    ld a5,  72(sp)
    ld a6,  80(sp)
    ld a7,  88(sp)
    ld t3,  96(sp)
    ld t4, 104(sp)
    ld t5, 112(sp)
    ld t6, 120(sp)

    # Deallocate stack space
    addi sp, sp, 256

    # Return from trap
    # mret restores PC from mepc and re-enables interrupts
    mret

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
 * ld    - Load Doubleword (64-bit)
 * wfi   - Wait For Interrupt
 * mret  - Machine-mode Return (return from trap)
 *
 * Trap handling:
 * - When interrupt/exception occurs, CPU jumps to address in mtvec
 * - CPU automatically saves PC to mepc and sets mcause
 * - Our handler must save/restore ALL registers
 * - mret instruction returns to mepc and restores previous state
 */
