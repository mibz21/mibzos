/*
 * clint.h - Core Local Interruptor (CLINT) register definitions
 *
 * The CLINT provides machine-mode timer interrupts and inter-processor
 * interrupts (IPI) via software interrupts.
 */

#ifndef CLINT_H
#define CLINT_H

#include <stdint.h>

/*
 * ============================================
 * CLINT Base Address
 * ============================================
 */

/* CLINT is mapped at this address on QEMU virt */
#define CLINT_BASE 0x02000000

/*
 * ============================================
 * CLINT Register Offsets
 * ============================================
 */

/*
 * Machine-mode Software Interrupt Pending
 * One register per hart, write 1 to trigger software interrupt
 */
#define CLINT_MSIP(hartid) (CLINT_BASE + 0x0000 + ((hartid) * 4))

/*
 * Machine-mode Timer Compare Register
 * When MTIME >= MTIMECMP, timer interrupt fires
 * One register per hart
 */
#define CLINT_MTIMECMP(hartid) (CLINT_BASE + 0x4000 + ((hartid) * 8))

/*
 * Machine-mode Time Register
 * 64-bit counter that increments at a fixed frequency (typically 10MHz on QEMU)
 * Shared across all harts
 */
#define CLINT_MTIME (CLINT_BASE + 0xBFF8)

/*
 * Convenience macros for single-hart systems (hart 0)
 */
#define MTIMECMP CLINT_MTIMECMP(0)
#define MTIME    CLINT_MTIME

/*
 * ============================================
 * Timer Configuration
 * ============================================
 */

/*
 * QEMU virt timer frequency: 10 MHz (10,000,000 Hz)
 * 1 second = 10,000,000 ticks
 */
#define TIMER_FREQ_HZ 10000000UL

/* Helper macro to convert milliseconds to timer ticks */
#define MS_TO_TICKS(ms) ((ms) * (TIMER_FREQ_HZ / 1000))

/* Helper macro to convert seconds to timer ticks */
#define SEC_TO_TICKS(sec) ((sec) * TIMER_FREQ_HZ)

/*
 * ============================================
 * CLINT Access Functions
 * ============================================
 */

/* Read 64-bit CLINT register */
static inline uint64_t clint_read_reg64(uint64_t addr)
{
    return *(volatile uint64_t *)addr;
}

/* Write 64-bit CLINT register */
static inline void clint_write_reg64(uint64_t addr, uint64_t value)
{
    *(volatile uint64_t *)addr = value;
}

/* Read current timer value */
static inline uint64_t clint_read_mtime(void)
{
    return clint_read_reg64(MTIME);
}

/* Write timer compare value for hart 0 */
static inline void clint_write_mtimecmp(uint64_t value)
{
    clint_write_reg64(MTIMECMP, value);
}

/* Trigger software interrupt for a specific hart */
static inline void clint_set_msip(uint64_t hartid)
{
    *(volatile uint32_t *)CLINT_MSIP(hartid) = 1;
}

/* Clear software interrupt for a specific hart */
static inline void clint_clear_msip(uint64_t hartid)
{
    *(volatile uint32_t *)CLINT_MSIP(hartid) = 0;
}

#endif /* CLINT_H */
