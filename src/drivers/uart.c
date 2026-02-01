/*
 * uart.c - UART driver for 16550A-compatible UART
 *
 * This driver provides basic UART I/O functionality for serial communication.
 */

#include "uart.h"

#include <stdint.h>

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
