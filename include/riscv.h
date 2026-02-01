/*
 * riscv.h - RISC-V architecture definitions
 *
 * This file contains RISC-V specific register definitions,
 * including Control and Status Registers (CSRs) and their bit fields.
 */

#ifndef RISCV_H
#define RISCV_H

#include <stdint.h>

/*
 * ============================================
 * Control and Status Registers (CSRs)
 * ============================================
 */

/* Machine Status Register */
#define CSR_MSTATUS 0x300
#define MSTATUS_MIE (1 << 3) /* Machine Interrupt Enable */
#define MSTATUS_MPIE (1 << 7) /* Machine Previous Interrupt Enable */

/* Machine Interrupt Enable Register */
#define CSR_MIE    0x304
#define MIE_MSIE   (1 << 3)  /* Machine Software Interrupt Enable */
#define MIE_MTIE   (1 << 7)  /* Machine Timer Interrupt Enable */
#define MIE_MEIE   (1 << 11) /* Machine External Interrupt Enable */

/* Machine Trap Vector */
#define CSR_MTVEC  0x305

/* Machine Exception Program Counter */
#define CSR_MEPC   0x341

/* Machine Cause Register */
#define CSR_MCAUSE 0x342

/* Machine Trap Value Register */
#define CSR_MTVAL  0x343

/* Machine Interrupt Pending */
#define CSR_MIP    0x344

/* Machine Hart ID */
#define CSR_MHARTID 0xF14

/*
 * ============================================
 * Interrupt Cause Codes (mcause with MSB=1)
 * ============================================
 */

#define CAUSE_MACHINE_SOFTWARE_INTERRUPT 0x8000000000000003UL
#define CAUSE_MACHINE_TIMER_INTERRUPT    0x8000000000000007UL
#define CAUSE_MACHINE_EXTERNAL_INTERRUPT 0x800000000000000BUL

/*
 * ============================================
 * Exception Cause Codes (mcause with MSB=0)
 * ============================================
 */

#define CAUSE_INSTRUCTION_MISALIGNED   0x0
#define CAUSE_INSTRUCTION_ACCESS_FAULT 0x1
#define CAUSE_ILLEGAL_INSTRUCTION      0x2
#define CAUSE_BREAKPOINT               0x3
#define CAUSE_LOAD_MISALIGNED          0x4
#define CAUSE_LOAD_ACCESS_FAULT        0x5
#define CAUSE_STORE_MISALIGNED         0x6
#define CAUSE_STORE_ACCESS_FAULT       0x7
#define CAUSE_ECALL_FROM_UMODE         0x8
#define CAUSE_ECALL_FROM_SMODE         0x9
#define CAUSE_ECALL_FROM_MMODE         0xB

/*
 * ============================================
 * MCAUSE Helper Macros
 * ============================================
 */

/* Check if mcause indicates an interrupt (vs exception) */
#define MCAUSE_IS_INTERRUPT(cause) ((cause) & 0x8000000000000000UL)

/* Extract exception/interrupt code from mcause */
#define MCAUSE_CODE(cause) ((cause) & 0x7FFFFFFFFFFFFFFFUL)

/*
 * ============================================
 * CSR Access Functions
 * ============================================
 */

/* Read CSR */
static inline uint64_t read_csr(uint64_t csr)
{
    uint64_t value;
    __asm__ volatile("csrr %0, %1" : "=r"(value) : "i"(csr));
    return value;
}

/* Write CSR */
static inline void write_csr(uint64_t csr, uint64_t value)
{
    __asm__ volatile("csrw %0, %1" : : "i"(csr), "r"(value));
}

/* Set bits in CSR (atomic OR operation) */
static inline void set_csr(uint64_t csr, uint64_t bits)
{
    __asm__ volatile("csrs %0, %1" : : "i"(csr), "r"(bits));
}

/* Clear bits in CSR (atomic AND-NOT operation) */
static inline void clear_csr(uint64_t csr, uint64_t bits)
{
    __asm__ volatile("csrc %0, %1" : : "i"(csr), "r"(bits));
}

#endif /* RISCV_H */
