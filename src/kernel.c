/*
 * kernel.c - Minimal RISC-V kernel demonstrating I/O
 *
 * This kernel demonstrates:
 * 1. Memory-mapped I/O (UART)
 * 2. How to write characters to serial port
 * 3. Basic string output
 */

#include <stdint.h>

/*
 * UART (Universal Asynchronous Receiver/Transmitter) Memory Map
 *
 * On QEMU virt machine, UART is at 0x10000000
 * This is a 16550A UART compatible device
 */
#define UART_BASE 0x10000000

/* UART registers */
#define UART_THR (UART_BASE + 0)  /* Transmit Holding Register */
#define UART_LSR (UART_BASE + 5)  /* Line Status Register */

/* Line Status Register bits */
#define LSR_THRE (1 << 5)  /* Transmitter Holding Register Empty */

/*
 * Read from memory-mapped I/O
 *
 * In C, we use volatile pointers to tell the compiler:
 * "This memory location can change without the program writing to it"
 * This prevents the compiler from optimizing away reads/writes.
 */
static inline uint8_t read_reg(uint64_t addr) {
    return *(volatile uint8_t *)addr;
}

/*
 * Write to memory-mapped I/O
 */
static inline void write_reg(uint64_t addr, uint8_t value) {
    *(volatile uint8_t *)addr = value;
}

/*
 * uart_putc - Write one character to UART
 *
 * This is the most basic I/O operation!
 * We write a byte to a memory address, and the hardware sends it.
 */
void uart_putc(char c) {
    /*
     * Wait until transmitter is ready
     *
     * The UART has a buffer. If we write too fast, data is lost.
     * LSR_THRE bit tells us when the transmitter is empty and ready.
     */
    while ((read_reg(UART_LSR) & LSR_THRE) == 0) {
        /* Busy wait - in real OS, we'd use interrupts */
    }

    /* Write character to transmit register */
    write_reg(UART_THR, c);
}

/*
 * uart_puts - Write a string to UART
 */
void uart_puts(const char *s) {
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
void uart_puthex(uint64_t value) {
    const char hex[] = "0123456789ABCDEF";
    uart_puts("0x");

    /* Print each nibble (4 bits) from most significant to least */
    for (int i = 60; i >= 0; i -= 4) {
        uart_putc(hex[(value >> i) & 0xF]);
    }
}

/*
 * Example: Read from a Control Status Register (CSR)
 *
 * CSRs are special RISC-V registers accessed with special instructions.
 * We need inline assembly for this.
 */
static inline uint64_t read_mhartid(void) {
    uint64_t hartid;
    __asm__ volatile ("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

static inline uint64_t read_mstatus(void) {
    uint64_t mstatus;
    __asm__ volatile ("csrr %0, mstatus" : "=r"(mstatus));
    return mstatus;
}

/*
 * kernel_main - Kernel entry point (called from boot.S)
 *
 * This function demonstrates basic I/O operations.
 * In a real kernel, this would set up interrupts, memory management, etc.
 */
void kernel_main(void) {
    /* Clear screen and print banner */
    uart_puts("\033[2J\033[H");  /* ANSI escape: clear screen, home cursor */
    uart_puts("====================================\n");
    uart_puts("  mibzOS - RISC-V Kernel v0.1\n");
    uart_puts("====================================\n\n");

    /* Demonstrate I/O by reading and printing CPU info */
    uart_puts("Boot Information:\n");

    uart_puts("  Hart ID:     ");
    uart_puthex(read_mhartid());
    uart_putc('\n');

    uart_puts("  Machine Status: ");
    uart_puthex(read_mstatus());
    uart_putc('\n');

    uart_puts("  UART Base:   ");
    uart_puthex(UART_BASE);
    uart_putc('\n');

    uart_puts("  RAM Start:   ");
    uart_puthex(0x80000000);
    uart_putc('\n');

    uart_puts("\nKernel I/O test complete!\n");
    uart_puts("Kernel is now halting...\n\n");

    /*
     * Halt the CPU
     *
     * In RISC-V, we use WFI (Wait For Interrupt) to idle.
     * Since we have no interrupts enabled, this effectively halts.
     */
    while (1) {
        __asm__ volatile ("wfi");
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
