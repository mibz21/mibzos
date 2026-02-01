/*
 * uart.h - 16550A UART register definitions
 *
 * This file contains memory-mapped register addresses and bit field
 * definitions for the 16550A UART device on QEMU virt machine.
 */

#ifndef UART_H
#define UART_H

#include <stdint.h>

/*
 * ============================================
 * UART Base Address
 * ============================================
 */

/* UART is mapped at this address on QEMU virt */
#define UART_BASE 0x10000000

/*
 * ============================================
 * UART Register Offsets
 * ============================================
 */

/* Note: RBR and THR share offset 0 (read vs write) */
#define UART_RBR (UART_BASE + 0) /* Receive Buffer Register (read-only) */
#define UART_THR (UART_BASE + 0) /* Transmit Holding Register (write-only) */
#define UART_IER (UART_BASE + 1) /* Interrupt Enable Register */
#define UART_FCR (UART_BASE + 2) /* FIFO Control Register (write-only) */
#define UART_ISR (UART_BASE + 2) /* Interrupt Status Register (read-only) */
#define UART_LCR (UART_BASE + 3) /* Line Control Register */
#define UART_MCR (UART_BASE + 4) /* Modem Control Register */
#define UART_LSR (UART_BASE + 5) /* Line Status Register */
#define UART_MSR (UART_BASE + 6) /* Modem Status Register */
#define UART_SCR (UART_BASE + 7) /* Scratch Register */

/*
 * ============================================
 * Line Status Register (LSR) Bits
 * ============================================
 */

#define LSR_DATA_READY (1 << 0) /* Data available to read */
#define LSR_OVERRUN    (1 << 1) /* Overrun error */
#define LSR_PARITY_ERR (1 << 2) /* Parity error */
#define LSR_FRAME_ERR  (1 << 3) /* Framing error */
#define LSR_BREAK      (1 << 4) /* Break signal received */
#define LSR_THRE       (1 << 5) /* Transmitter Holding Register Empty */
#define LSR_IDLE       (1 << 6) /* Transmitter idle */

/*
 * ============================================
 * Interrupt Enable Register (IER) Bits
 * ============================================
 */

#define IER_RX_AVAILABLE (1 << 0) /* Enable receive data interrupt */
#define IER_TX_EMPTY     (1 << 1) /* Enable transmit empty interrupt */
#define IER_LINE_STATUS  (1 << 2) /* Enable line status interrupt */
#define IER_MODEM_STATUS (1 << 3) /* Enable modem status interrupt */

/*
 * ============================================
 * UART I/O Helper Functions
 * ============================================
 */

/* Read 8-bit UART register */
static inline uint8_t uart_read_reg(uint64_t addr)
{
    return *(volatile uint8_t *)addr;
}

/* Write 8-bit UART register */
static inline void uart_write_reg(uint64_t addr, uint8_t value)
{
    *(volatile uint8_t *)addr = value;
}

/*
 * ============================================
 * UART I/O Functions
 * ============================================
 */

/* Write one character to UART */
void uart_putc(char c);

/* Write a string to UART */
void uart_puts(const char *s);

/* Write a 64-bit hex value to UART */
void uart_puthex(uint64_t value);

/* Read one character from UART (blocking) */
char uart_getc(void);

#endif /* UART_H */
