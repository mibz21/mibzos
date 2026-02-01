# mibzOS

A minimal RISC-V operating system kernel built from scratch for learning and exploration.

## Overview

mibzOS is a bare-metal kernel that runs on RISC-V architecture, demonstrating fundamental OS concepts including:
- Boot process and hardware initialization
- Memory-mapped I/O
- Direct hardware access without OS abstraction
- UART serial communication

## Project Structure

```
mibzos/
├── src/
│   ├── boot.S         # Assembly bootstrap code (sets up stack, clears BSS)
│   ├── kernel.c       # C kernel with I/O operations
│   └── linker.ld      # Linker script (memory layout)
├── build/             # Compiled artifacts (generated)
│   ├── kernel.elf     # Final kernel executable
│   ├── kernel.bin     # Raw binary image
│   ├── kernel.asm     # Disassembly listing
│   ├── boot.o         # Compiled assembly
│   └── kernel.o       # Compiled C code
├── Makefile           # Build system
├── README.md          # This file
└── CLAUDE.md          # AI assistant context
```

## Prerequisites

### macOS Setup

Install the RISC-V toolchain and QEMU emulator:

```bash
# Add RISC-V tap
brew tap riscv-software-src/riscv

# Install cross-compiler toolchain
brew install riscv-gnu-toolchain

# Install QEMU emulator
brew install qemu
```

### Verify Installation

```bash
riscv64-unknown-elf-gcc --version
qemu-system-riscv64 --version
```

## Quick Start

### Build the Kernel

```bash
make
```

This will:
1. Assemble `boot.S` → `boot.o`
2. Compile `kernel.c` → `kernel.o`
3. Link both → `kernel.elf`
4. Generate `kernel.bin` (raw binary)
5. Generate `kernel.asm` (disassembly)

### Run in QEMU

```bash
make run
```

You should see:
```
====================================
  mibzOS - RISC-V Kernel v0.1
====================================

Boot Information:
  Hart ID:     0x0000000000000000
  Machine Status: 0x0000000A00000000
  UART Base:   0x0000000010000000
  RAM Start:   0x0000000080000000

Kernel I/O test complete!
Kernel is now halting...
```

**Exit QEMU**: Press `Ctrl+A` then `X`

### Other Make Commands

```bash
make clean        # Remove all build artifacts
make debug        # Start QEMU in debug mode (waits for GDB)
make info         # Show kernel size, sections, and symbols
```

## Debugging

### Using GDB

Terminal 1:
```bash
make debug
```

Terminal 2:
```bash
riscv64-unknown-elf-gdb build/kernel.elf
(gdb) target remote localhost:1234
(gdb) break kernel_main
(gdb) continue
(gdb) info registers
(gdb) x/10i $pc              # Disassemble next 10 instructions
(gdb) x/16x 0x80000000       # Examine memory
```

## OS Basics

### How This Kernel Works

1. **Boot Process** (`boot.S`):
   - Disable interrupts
   - Check hart (CPU core) ID - only hart 0 continues
   - Set up stack pointer
   - Clear BSS section (uninitialized data)
   - Jump to C code (`kernel_main`)

2. **Kernel Execution** (`kernel.c`):
   - Perform memory-mapped I/O to UART (serial port)
   - Print system information
   - Halt CPU using WFI (Wait For Interrupt)

3. **Memory Layout** (`linker.ld`):
   - Code starts at `0x80000000` (RAM base on QEMU virt machine)
   - Sections: `.text` (code), `.rodata` (constants), `.data`, `.bss`
   - Stack allocated at end

### Key Concepts

#### Memory-Mapped I/O

Hardware devices are accessed by reading/writing to specific memory addresses:

```c
#define UART_BASE 0x10000000
*(volatile uint8_t *)UART_BASE = 'H';  // Sends 'H' to serial port
```

#### Bare-Metal Programming

- No operating system underneath
- No standard library (`printf`, `malloc`, etc.)
- Direct hardware access
- Must manually initialize everything

#### Cross-Compilation

Your Mac (ARM64/x86_64) compiles code for RISC-V:
```
Mac → riscv64-unknown-elf-gcc → RISC-V binary → QEMU emulator
```

## Contributing

### Adding Features

Here are some ideas for extending mibzOS:

#### 1. Basic Features
- [ ] Read input from UART (keyboard input)
- [ ] Support ANSI colors in output
- [ ] Implement a simple shell/command interpreter
- [ ] Add formatted printing (like `printf`)

#### 2. Interrupts
- [ ] Set up trap/interrupt handlers
- [ ] Timer interrupts
- [ ] UART receive interrupts
- [ ] Exception handling (page faults, illegal instructions)

#### 3. Memory Management
- [ ] Dynamic memory allocation (heap)
- [ ] Page tables and virtual memory
- [ ] Memory protection
- [ ] Kernel/user space separation

#### 4. Multitasking
- [ ] Context switching
- [ ] Simple round-robin scheduler
- [ ] Process/thread structures
- [ ] System calls

#### 5. Drivers
- [ ] VirtIO block device (disk)
- [ ] VirtIO network device
- [ ] Framebuffer/graphics
- [ ] RTC (Real-Time Clock)

#### 6. File System
- [ ] RAM disk
- [ ] Simple file system (FAT, ext2, or custom)
- [ ] VFS (Virtual File System) layer

### Code Style

- **C Code**: Use clear, well-commented code
- **Assembly**: Comment every non-obvious instruction
- **Naming**: Use descriptive names (`uart_putc` not `up`)
- **Documentation**: Update README/CLAUDE.md when adding major features

### Development Workflow

1. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/timer-interrupts
   ```

2. **Make changes** and test:
   ```bash
   make clean && make run
   ```

3. **Verify build** with different flags:
   ```bash
   make clean && make CFLAGS+="-Werror"
   ```

4. **Check disassembly** if behavior is unexpected:
   ```bash
   less build/kernel.asm
   ```

5. **Debug** if needed:
   ```bash
   make debug
   ```

6. **Commit and document**:
   ```bash
   git add .
   git commit -m "Add timer interrupt support"
   ```

### Testing Changes

- Always test in QEMU before committing
- Check for warnings: `make CFLAGS+="-Wall -Wextra -Werror"`
- Verify disassembly looks correct
- Test edge cases (what if UART is not ready?)

## Architecture Details

### RISC-V Specifics

- **Architecture**: RV64GC (64-bit with general extensions + compressed)
- **Privilege Levels**: Currently running in Machine mode (M-mode)
- **Hart**: Hardware thread (like a CPU core)

### Memory Map (QEMU virt)

```
0x00000000 - 0x00000FFF: Debug/ROM
0x10000000 - 0x100000FF: UART (16550A)
0x80000000 - 0x88000000: RAM (128MB)
```

### UART Registers

- **THR** (Transmit Holding Register, offset +0): Write byte to send
- **LSR** (Line Status Register, offset +5): Read status
  - Bit 5 (THRE): Transmitter ready

## Learning Resources

### RISC-V
- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- [RISC-V Assembly Programmer's Manual](https://github.com/riscv-non-isa/riscv-asm-manual)

### OS Development
- [OSDev Wiki](https://wiki.osdev.org/)
- [The little book about OS development](https://littleosbook.github.io/)
- [Writing an OS in Rust](https://os.phil-opp.com/) (good concepts, different language)

### QEMU
- [QEMU RISC-V Documentation](https://www.qemu.org/docs/master/system/target-riscv.html)
- [QEMU virt machine source](https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c)

## License

This is a learning project. Feel free to use, modify, and learn from the code.

## Acknowledgments

Built for learning RISC-V architecture and operating system fundamentals.
