# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

mibzOS is a bare-metal RISC-V operating system kernel built from scratch for educational purposes. It demonstrates fundamental OS concepts including boot process, memory-mapped I/O, and direct hardware access.

## Current State

The project has a working minimal kernel with:
- Boot assembly code (`src/boot.S`) that initializes the CPU
- C kernel (`src/kernel.c`) with UART I/O capabilities
- Linker script (`src/linker.ld`) defining memory layout
- Makefile-based build system
- QEMU emulator support for testing

## Development Environment

### Required Tools

1. **RISC-V Cross-Compiler Toolchain**
   ```bash
   brew tap riscv-software-src/riscv
   brew install riscv-gnu-toolchain
   ```
   - Provides: `riscv64-unknown-elf-gcc`, `riscv64-unknown-elf-ld`, `riscv64-unknown-elf-objdump`

2. **QEMU Emulator**
   ```bash
   brew install qemu
   ```
   - Provides: `qemu-system-riscv64`, `qemu-system-riscv32`

### Build Commands

```bash
make           # Build kernel
make run       # Run in QEMU (Ctrl+A then X to exit)
make debug     # Start QEMU waiting for GDB
make clean     # Remove build artifacts
make info      # Show kernel information
```

## Architecture

### Target Platform
- **Architecture**: RISC-V RV64GC (64-bit with general extensions + compressed instructions)
- **Machine**: QEMU virt (virtual RISC-V platform)
- **Privilege Mode**: Machine mode (M-mode) - highest privilege level
- **ABI**: lp64d (longs/pointers 64-bit, double-precision FP)

### Memory Map (QEMU virt)
```
0x00000000 - 0x00000FFF: Debug/Boot ROM
0x10000000 - 0x100000FF: UART (16550A compatible)
0x80000000 - 0x88000000: RAM (128MB, kernel loads here)
```

### Boot Process Flow
```
QEMU loads kernel.elf
    ↓
_start (boot.S)
    ↓
1. Disable interrupts (csrw mie, zero)
2. Check hart ID (only hart 0 continues)
3. Set up stack pointer (la sp, __stack_top)
4. Clear BSS section (zero uninitialized data)
    ↓
kernel_main (kernel.c)
    ↓
1. Initialize UART
2. Print boot information
3. Halt CPU (wfi loop)
```

## Code Organization

### src/boot.S
Assembly bootstrap code that:
- Runs before any C code can execute
- Initializes CPU state (stack pointer, BSS)
- Handles multi-hart boot (only hart 0 continues)
- Must not use stack until sp is set up

**Key Sections:**
- `.text.boot`: Placed first by linker script to ensure _start is entry point
- `_start`: Entry point called by QEMU
- `clear_bss`: Loop to zero BSS section
- `halt`: Infinite WFI loop for non-boot harts

### src/kernel.c
C kernel code that:
- Performs memory-mapped I/O to UART
- Demonstrates bare-metal programming (no libc)
- Uses `volatile` for hardware registers (critical!)
- Reads CPU CSRs using inline assembly

**Key Functions:**
- `read_reg()` / `write_reg()`: Memory-mapped I/O wrappers with volatile
- `uart_putc()`: Send one character (polls LSR for ready status)
- `uart_puts()`: Send string (handles \r\n conversion)
- `uart_puthex()`: Print 64-bit hex values
- `kernel_main()`: Entry point called from boot.S

### src/linker.ld
Linker script that:
- Defines memory layout (RAM starts at 0x80000000)
- Orders sections (.text.boot first, then .text, .rodata, .data, .bss)
- Exports symbols for boot.S (__bss_start, __bss_end, __stack_top)
- Sets entry point to _start

**Important Symbols:**
- `__bss_start` / `__bss_end`: Used by boot.S to clear BSS
- `__stack_top`: Stack pointer initial value
- `__kernel_end`: End of kernel in memory

## Important Concepts

### Memory-Mapped I/O
Hardware devices are accessed by reading/writing specific memory addresses:
```c
#define UART_THR 0x10000000  // Transmit register
*(volatile uint8_t *)UART_THR = 'H';  // Sends 'H' to serial
```

**Critical:** Always use `volatile` to prevent compiler optimizations that would break I/O.

### Bare-Metal Programming
- No operating system or standard library
- No `printf()`, `malloc()`, system calls
- Direct hardware access only
- Must initialize everything manually

### Cross-Compilation
Code is compiled on macOS (ARM64/x86_64) for RISC-V architecture:
- Use `riscv64-unknown-elf-*` tools (not native `gcc`, `ld`)
- Compiler flags: `-ffreestanding -nostdlib` (no OS/libc)
- Target flags: `-march=rv64gc -mabi=lp64d`

### RISC-V Assembly Basics
- **Registers**: x0-x31 (x0 always zero, x2=sp, x1=ra)
- **CSRs**: Special registers (mhartid, mstatus, mie)
- **Load/Store**: Memory accessed via `ld`/`sd`, not directly in ALU ops
- **Pseudos**: `la`, `li`, `call`, `ret` expand to multiple instructions

## Common Development Tasks

### Adding New C Functions
1. Declare in kernel.c (static for internal, or in header for external)
2. Use `volatile` for any hardware I/O
3. Use inline assembly for CSR access
4. Test in QEMU with `make run`

### Adding New Assembly Code
1. Place in boot.S or create new .S file
2. Add to ASM_SOURCES in Makefile
3. Use `.global` for symbols accessed from C
4. Comment every non-obvious instruction
5. Remember: no stack available before `la sp, __stack_top`

### Debugging
1. Build with `make` (includes `-g` debug symbols)
2. Run `make debug` in one terminal
3. In another terminal: `riscv64-unknown-elf-gdb build/kernel.elf`
4. GDB commands:
   ```
   target remote localhost:1234
   break kernel_main
   continue
   info registers
   x/10i $pc      # Disassemble
   x/16x 0x80000000   # Examine memory
   ```

### Inspecting Build Artifacts
- `build/kernel.asm`: Full disassembly (very useful!)
- `make info`: Shows sections, symbols, sizes
- `riscv64-unknown-elf-objdump -d build/kernel.elf`: Manual disassembly
- `riscv64-unknown-elf-readelf -a build/kernel.elf`: ELF structure

## Potential Next Features

When implementing new features, consider this order:

1. **UART Input**: Read characters from serial (extends current I/O)
2. **Interrupts**: Timer and UART interrupts (foundational for everything else)
3. **Memory Allocator**: Dynamic allocation for kernel data structures
4. **Multitasking**: Context switching and scheduler
5. **Virtual Memory**: Page tables and MMU setup
6. **Drivers**: VirtIO block/network devices
7. **File System**: Simple FS on RAM disk or VirtIO block

## Common Pitfalls

1. **Forgetting `volatile`**: Compiler will optimize away I/O operations
2. **Using stack in boot.S before setup**: Crashes immediately
3. **Not handling multi-hart boot**: All harts run _start simultaneously
4. **Wrong memory addresses**: UART is at 0x10000000, not 0x80000000
5. **Linker script errors**: Sections must be ordered correctly (.text.boot first)
6. **Missing CFLAGS**: `-ffreestanding -nostdlib` are required

## Code Style Guidelines

- **Comments**: Explain why, not what (code shows what)
- **Assembly**: Comment every instruction that isn't obvious
- **C code**: Use descriptive names (`uart_transmit_byte` not `tx`)
- **Magic numbers**: Define as constants (`#define UART_BASE 0x10000000`)
- **Inline assembly**: Document constraints and side effects

## Testing Strategy

Before committing:
1. `make clean && make` - Verify clean build
2. `make run` - Test in QEMU
3. Check `build/kernel.asm` - Verify generated code looks correct
4. Test edge cases (e.g., rapid UART writes)
5. Verify no warnings: `make CFLAGS+="-Werror"`

## References

- RISC-V spec: https://riscv.org/technical/specifications/
- QEMU virt source: https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c
- 16550A UART datasheet: https://www.ti.com/lit/ds/symlink/pc16550d.pdf
- OSDev wiki: https://wiki.osdev.org/
