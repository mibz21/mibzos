/*
 * kernel.c - Minimal RISC-V kernel demonstrating I/O
 *
 * This kernel demonstrates:
 * 1. Memory-mapped I/O (UART)
 * 2. How to write characters to serial port
 * 3. Basic string output
 * 4. Interrupt handling
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Hardware register definitions */
#include "clint.h"
#include "memory_allocator.h"
#include "riscv.h"
#include "uart.h"

/*
 * uart_putc - Write one character to UART
 *
 * This is the most basic I/O operation!
 * We write a byte to a memory address, and the hardware sends it.
 */
void uart_putc(char c)
{
    /*
     * Wait until transmitter is ready
     *
     * The UART has a buffer. If we write too fast, data is lost.
     * LSR_THRE bit tells us when the transmitter is empty and ready.
     */
    while ((uart_read_reg(UART_LSR) & LSR_THRE) == 0) {
        /* Busy wait - in real OS, we'd use interrupts */
    }

    /* Write character to transmit register */
    uart_write_reg(UART_THR, c);
}

/*
 * uart_puts - Write a string to UART
 */
void uart_puts(const char *s)
{
    while (*s) {
        /* Handle newlines properly (CR+LF for terminal) */
        if (*s == '\n') {
            uart_putc('\r');
        }
        uart_putc(*s++);
    }
}

/*
 * uart_puthex - Write a 64-bit hex value to UART
 *
 * Demonstrates manual conversion and I/O
 */
void uart_puthex(uint64_t value)
{
    const char hex[] = "0123456789ABCDEF";
    uart_puts("0x");

    /* Print each nibble (4 bits) from most significant to least */
    for (int i = 60; i >= 0; i -= 4) {
        uart_putc(hex[(value >> i) & 0xF]);
    }
}

/*
 * uart_getc - Read one character from UART (blocking)
 *
 * This is the input counterpart to uart_putc.
 * It waits until a character is available, then reads it.
 *
 * Note: This is BLOCKING - it will wait forever if no input arrives.
 * In a real OS, you'd want a timeout or interrupt-driven approach.
 */
char uart_getc(void)
{
    /*
     * Wait until data is ready
     *
     * The LSR_DATA_READY bit is set by hardware when a byte arrives.
     * We poll this bit until it becomes 1.
     */
    while ((uart_read_reg(UART_LSR) & LSR_DATA_READY) == 0) {
        /* Busy wait - in real OS, we'd use interrupts */
    }

    /* Read character from receive buffer */
    return uart_read_reg(UART_RBR);
}

/*
 * ============================================
 * Interrupt and Timer Handling
 * ============================================
 */

/* Global tick counter - increments every timer interrupt */
static volatile uint64_t timer_ticks = 0;

/* Timer interval (1 second) */
#define TIMER_INTERVAL SEC_TO_TICKS(1)

/*
 * Individual Interrupt Handlers
 */

/*
 * handle_timer_interrupt - Machine timer interrupt handler
 */
static void handle_timer_interrupt(void)
{
    /* Increment tick counter */
    timer_ticks++;

    /* Print a message every second (for debugging) */
    if (timer_ticks % 1 == 0) {
        uart_puts("[Timer tick ");
        uart_puthex(timer_ticks);
        uart_puts("]\n");
    }

    /* Schedule next timer interrupt */
    uint64_t next = clint_read_mtime() + TIMER_INTERVAL;
    clint_write_mtimecmp(next);
}

/*
 * handle_software_interrupt - Machine software interrupt handler
 */
static void handle_software_interrupt(void)
{
    uart_puts("[Software interrupt]\n");
    /* TODO: Handle inter-processor interrupts (IPI) */
}

/*
 * handle_external_interrupt - Machine external interrupt handler
 */
static void handle_external_interrupt(void)
{
    uart_puts("[External interrupt]\n");
    /* TODO: Handle PLIC (Platform-Level Interrupt Controller) interrupts */
}

/*
 * Individual Exception Handlers
 */

/*
 * handle_illegal_instruction - Illegal instruction exception
 */
static void handle_illegal_instruction(void)
{
    uart_puts("\n!!! EXCEPTION: Illegal Instruction\n");
    uart_puts("    MEPC: ");
    uart_puthex(read_csr(CSR_MEPC));
    uart_puts("\n");

    /* Halt on exception */
    while (1) {
        __asm__ volatile("wfi");
    }
}

/*
 * handle_load_fault - Load access fault exception
 */
static void handle_load_fault(void)
{
    uart_puts("\n!!! EXCEPTION: Load Access Fault\n");
    uart_puts("    MEPC:  ");
    uart_puthex(read_csr(CSR_MEPC));
    uart_puts("\n");
    uart_puts("    MTVAL: ");
    uart_puthex(read_csr(CSR_MTVAL));
    uart_puts("\n");

    /* Halt on exception */
    while (1) {
        __asm__ volatile("wfi");
    }
}

/*
 * handle_store_fault - Store access fault exception
 */
static void handle_store_fault(void)
{
    uart_puts("\n!!! EXCEPTION: Store Access Fault\n");
    uart_puts("    MEPC:  ");
    uart_puthex(read_csr(CSR_MEPC));
    uart_puts("\n");
    uart_puts("    MTVAL: ");
    uart_puthex(read_csr(CSR_MTVAL));
    uart_puts("\n");

    /* Halt on exception */
    while (1) {
        __asm__ volatile("wfi");
    }
}

/*
 * handle_unknown_trap - Fallback for unhandled traps
 */
static void handle_unknown_trap(uint64_t mcause)
{
    if (MCAUSE_IS_INTERRUPT(mcause)) {
        uart_puts("\n!!! Unknown INTERRUPT: ");
    } else {
        uart_puts("\n!!! Unknown EXCEPTION: ");
    }
    uart_puts("mcause = ");
    uart_puthex(mcause);
    uart_puts("\n");

    /* Halt on unknown trap */
    while (1) {
        __asm__ volatile("wfi");
    }
}

/*
 * handle_trap - Main trap dispatcher
 *
 * This is called from trap_handler in boot.S.
 * It reads mcause and dispatches to the appropriate handler.
 *
 * This is much cleaner than a giant if/else chain!
 */
void handle_trap(void)
{
    uint64_t mcause = read_csr(CSR_MCAUSE);

    /* Dispatch based on trap cause */
    if (MCAUSE_IS_INTERRUPT(mcause)) {
        /* It's an interrupt - dispatch to interrupt handler */
        switch (mcause) {
        case CAUSE_MACHINE_SOFTWARE_INTERRUPT:
            handle_software_interrupt();
            break;
        case CAUSE_MACHINE_TIMER_INTERRUPT:
            handle_timer_interrupt();
            break;
        case CAUSE_MACHINE_EXTERNAL_INTERRUPT:
            handle_external_interrupt();
            break;
        default:
            handle_unknown_trap(mcause);
            break;
        }
    } else {
        /* It's an exception - dispatch to exception handler */
        uint64_t code = MCAUSE_CODE(mcause);
        switch (code) {
        case CAUSE_ILLEGAL_INSTRUCTION:
            handle_illegal_instruction();
            break;
        case CAUSE_LOAD_ACCESS_FAULT:
        case CAUSE_LOAD_MISALIGNED:
            handle_load_fault();
            break;
        case CAUSE_STORE_ACCESS_FAULT:
        case CAUSE_STORE_MISALIGNED:
            handle_store_fault();
            break;
        default:
            handle_unknown_trap(mcause);
            break;
        }
    }
}

/*
 * timer_init - Initialize and enable timer interrupts
 *
 * This sets up the RISC-V timer to generate periodic interrupts.
 */
void timer_init(void)
{
    /* Declare trap_handler (defined in boot.S) */
    extern void trap_handler(void);

    uart_puts("\nInitializing timer interrupts...\n");

    /* Set trap vector to our handler */
    write_csr(CSR_MTVEC, (uint64_t)trap_handler);
    uart_puts("  Trap vector set\n");

    /* Schedule first timer interrupt */
    uint64_t now = clint_read_mtime();
    clint_write_mtimecmp(now + TIMER_INTERVAL);
    uart_puts("  First interrupt scheduled\n");

    /* Enable timer interrupts in mie register */
    set_csr(CSR_MIE, MIE_MTIE);
    uart_puts("  Timer interrupts enabled in MIE\n");

    /* Enable global interrupts in mstatus register */
    set_csr(CSR_MSTATUS, MSTATUS_MIE);
    uart_puts("  Global interrupts enabled\n");

    uart_puts("Timer initialization complete!\n\n");
}

static void test_memory_allocator_and_free(void)
{
    uart_puts("\n=== Memory Allocator Test Suite ===\n\n");

    /* Test 1: Basic allocation */
    uart_puts("Test 1: Basic allocation\n");
    void *ptr1 = kmalloc(64);
    if (ptr1 != NULL) {
        uart_puts("  Allocated 64 bytes at ");
        uart_puthex((uint64_t)ptr1);
        uart_puts("\n");
    } else {
        uart_puts("  FAILED: Allocation failed!\n");
        return;
    }

    void *ptr2 = kmalloc(128);
    if (ptr2 != NULL) {
        uart_puts("  Allocated 128 bytes at ");
        uart_puthex((uint64_t)ptr2);
        uart_puts("\n");
    } else {
        uart_puts("  FAILED: Allocation failed!\n");
        return;
    }

    void *ptr3 = kmalloc(256);
    if (ptr3 != NULL) {
        uart_puts("  Allocated 256 bytes at ");
        uart_puthex((uint64_t)ptr3);
        uart_puts("\n");
    } else {
        uart_puts("  FAILED: Allocation failed!\n");
        return;
    }

    /* Test 2: Free middle block and verify reuse */
    uart_puts("\nTest 2: Free middle block (ptr2)\n");
    kfree(ptr2);
    uart_puts("  Freed 128 bytes at ");
    uart_puthex((uint64_t)ptr2);
    uart_puts("\n");

    /* Allocate same size - should reuse the freed block */
    void *ptr4 = kmalloc(128);
    if (ptr4 != NULL) {
        uart_puts("  Allocated 128 bytes at ");
        uart_puthex((uint64_t)ptr4);
        if (ptr4 == ptr2) {
            uart_puts(" [PASS: Reused freed block]\n");
        } else {
            uart_puts(" [INFO: Different block used]\n");
        }
    } else {
        uart_puts("  FAILED: Allocation failed!\n");
        return;
    }

    /* Test 3: Free adjacent blocks and verify coalescing */
    uart_puts("\nTest 3: Test coalescing (free ptr1, ptr4, ptr3)\n");
    uart_puts("  Freeing ptr1 at ");
    uart_puthex((uint64_t)ptr1);
    uart_puts("\n");
    kfree(ptr1);

    uart_puts("  Freeing ptr4 at ");
    uart_puthex((uint64_t)ptr4);
    uart_puts("\n");
    kfree(ptr4);

    uart_puts("  Freeing ptr3 at ");
    uart_puthex((uint64_t)ptr3);
    uart_puts("\n");
    kfree(ptr3);

    /* Test 4: Allocate large block to verify coalescing worked */
    uart_puts("\nTest 4: Allocate large block after coalescing\n");
    void *ptr5 = kmalloc(512);
    if (ptr5 != NULL) {
        uart_puts("  Allocated 512 bytes at ");
        uart_puthex((uint64_t)ptr5);
        uart_puts(" [PASS: Coalescing successful]\n");
        kfree(ptr5);
    } else {
        uart_puts("  FAILED: Large allocation failed (coalescing may have failed)\n");
        return;
    }

    /* Test 5: Allocate small block in freed space */
    uart_puts("\nTest 5: Allocate small block\n");
    void *ptr6 = kmalloc(32);
    if (ptr6 != NULL) {
        uart_puts("  Allocated 32 bytes at ");
        uart_puthex((uint64_t)ptr6);
        uart_puts("\n");
        kfree(ptr6);
    } else {
        uart_puts("  FAILED: Small allocation failed!\n");
        return;
    }

    /* Test 6: Edge cases */
    uart_puts("\nTest 6: Edge cases\n");
    void *ptr_zero = kmalloc(0);
    if (ptr_zero == NULL) {
        uart_puts("  PASS: kmalloc(0) returned NULL\n");
    } else {
        uart_puts("  FAILED: kmalloc(0) should return NULL\n");
    }

    kfree(NULL);
    uart_puts("  PASS: kfree(NULL) handled gracefully\n");

    uart_puts("\n=== All tests completed ===\n\n");
}

/*
 * kernel_main - Kernel entry point (called from boot.S)
 *
 * This function demonstrates basic I/O operations.
 * In a real kernel, this would set up interrupts, memory management, etc.
 */
void kernel_main(void)
{
    /* Clear screen and print banner */
    uart_puts("\033[2J\033[H"); /* ANSI escape: clear screen, home cursor */
    uart_puts("====================================\n");
    uart_puts("  mibzOS - RISC-V Kernel v0.1\n");
    uart_puts("====================================\n\n");

    /* Demonstrate I/O by reading and printing CPU info */
    uart_puts("Boot Information:\n");

    uart_puts("  Hart ID:     ");
    uart_puthex(read_csr(CSR_MHARTID));
    uart_putc('\n');

    uart_puts("  Machine Status: ");
    uart_puthex(read_csr(CSR_MSTATUS));
    uart_putc('\n');

    uart_puts("  UART Base:   ");
    uart_puthex(UART_BASE);
    uart_putc('\n');

    uart_puts("  RAM Start:   ");
    uart_puthex(0x80000000);
    uart_putc('\n');

    uart_puts("\nKernel I/O test complete!\n");

    /* Initialize memory allocator */
    mem_init();

    /* Initialize timer interrupts */
    timer_init();

    uart_puts("=== Timer Interrupt Demo ===\n");
    uart_puts("You should see timer ticks appearing every second.\n");
    uart_puts("Press Ctrl+A then X to exit QEMU\n\n");

    /* Test memory allocator and free */
    test_memory_allocator_and_free();

    /*
     * Main kernel loop
     *
     * With interrupts enabled, the timer will fire automatically.
     * We can do other work here (or just idle with WFI).
     */
    while (1) {
        /*
         * WFI (Wait For Interrupt) puts CPU in low-power mode
         * until an interrupt arrives. This is more efficient than
         * busy-waiting in an empty loop.
         */
        __asm__ volatile("wfi");
    }
}

/*
 * === HOW I/O WORKS IN A KERNEL ===
 *
 * 1. MEMORY-MAPPED I/O:
 *    Hardware devices are mapped to memory addresses.
 *    Reading/writing to these addresses communicates with hardware.
 *
 *    Example: Writing to 0x10000000 sends a byte via UART.
 *
 * 2. NO OPERATING SYSTEM:
 *    There's no printf(), no syscalls, no drivers.
 *    We ARE the operating system. We access hardware directly.
 *
 * 3. VOLATILE:
 *    The 'volatile' keyword is CRITICAL for I/O.
 *    It tells the compiler: "This memory can change unexpectedly"
 *    Without it, the compiler might optimize away your I/O!
 *
 * 4. POLLING vs INTERRUPTS:
 *    - Polling: Check status register repeatedly (inefficient, but simple)
 *    - Interrupts: Hardware notifies CPU when ready (efficient, but complex)
 *
 *    This kernel uses polling for simplicity.
 *
 * 5. DEVICE TREE / DOCUMENTATION:
 *    How do we know UART is at 0x10000000?
 *    - QEMU virt machine documentation
 *    - Device tree (more advanced)
 *    - Hardware datasheets (for real hardware)
 *
 * 6. REGISTERS:
 *    Each device has control/status/data registers.
 *    UART example:
 *    - THR (Transmit Holding Register): Write data here to send
 *    - LSR (Line Status Register): Read status (ready? error?)
 *
 * 7. INLINE ASSEMBLY:
 *    Some things can't be done in C (like reading CSRs).
 *    We use inline assembly for CPU-specific operations.
 *
 *    Format: __asm__ volatile ("instruction" : outputs : inputs : clobbers);
 */
