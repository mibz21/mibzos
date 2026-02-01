# Makefile for mibzOS RISC-V kernel

# Toolchain configuration
CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

# Directories
SRC_DIR = src
BUILD_DIR = build

# Compiler flags
CFLAGS = -Wall -Wextra -O2 -g
CFLAGS += -ffreestanding       # No standard library
CFLAGS += -nostdlib            # Don't link standard library
CFLAGS += -march=rv64gc        # RISC-V 64-bit with extensions
CFLAGS += -mabi=lp64d          # ABI: Long and Pointer are 64-bit, Double FP
CFLAGS += -mcmodel=medany      # Code model for position-independent code

# Linker flags
LDFLAGS = -nostdlib -T $(SRC_DIR)/linker.ld

# Source files
ASM_SOURCES = $(SRC_DIR)/boot.S
C_SOURCES = $(SRC_DIR)/kernel.c

# Object files
ASM_OBJECTS = $(BUILD_DIR)/boot.o
C_OBJECTS = $(BUILD_DIR)/kernel.o
OBJECTS = $(ASM_OBJECTS) $(C_OBJECTS)

# Output files
KERNEL_ELF = $(BUILD_DIR)/kernel.elf
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
KERNEL_ASM = $(BUILD_DIR)/kernel.asm

# Default target
all: $(KERNEL_ELF) $(KERNEL_BIN) $(KERNEL_ASM)
	@echo "Build complete!"
	@echo "  Kernel ELF: $(KERNEL_ELF)"
	@echo "  Kernel BIN: $(KERNEL_BIN)"
	@echo "  Disassembly: $(KERNEL_ASM)"

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile assembly files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S | $(BUILD_DIR)
	@echo "Assembling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Compile C files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Link kernel
$(KERNEL_ELF): $(OBJECTS)
	@echo "Linking kernel..."
	$(LD) $(LDFLAGS) -o $@ $^

# Create raw binary (optional, useful for some bootloaders)
$(KERNEL_BIN): $(KERNEL_ELF)
	@echo "Creating binary image..."
	$(OBJCOPY) -O binary $< $@

# Generate disassembly (useful for debugging)
$(KERNEL_ASM): $(KERNEL_ELF)
	@echo "Generating disassembly..."
	$(OBJDUMP) -D $< > $@

# Run in QEMU
run: $(KERNEL_ELF)
	@echo "Starting QEMU..."
	@echo "Press Ctrl+A then X to exit QEMU"
	qemu-system-riscv64 \
		-machine virt \
		-cpu rv64 \
		-m 128M \
		-nographic \
		-serial mon:stdio \
		-bios none \
		-kernel $(KERNEL_ELF)

# Debug in QEMU (waits for GDB connection)
debug: $(KERNEL_ELF)
	@echo "Starting QEMU in debug mode..."
	@echo "Connect with: $(CROSS_COMPILE)gdb $(KERNEL_ELF)"
	@echo "Then in GDB: target remote localhost:1234"
	qemu-system-riscv64 \
		-machine virt \
		-cpu rv64 \
		-m 128M \
		-nographic \
		-serial mon:stdio \
		-bios none \
		-kernel $(KERNEL_ELF) \
		-s \
		-S

# Clean build artifacts
clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)

# Show information about the kernel
info: $(KERNEL_ELF)
	@echo "=== Kernel Information ==="
	@echo
	@echo "File size:"
	@ls -lh $(KERNEL_ELF) | awk '{print "  " $$9 ": " $$5}'
	@echo
	@echo "Section headers:"
	@$(CROSS_COMPILE)readelf -S $(KERNEL_ELF)
	@echo
	@echo "Program headers:"
	@$(CROSS_COMPILE)readelf -l $(KERNEL_ELF)
	@echo
	@echo "Symbols:"
	@$(CROSS_COMPILE)nm -n $(KERNEL_ELF)

# Phony targets (not actual files)
.PHONY: all run debug clean info

# Keep intermediate files
.PRECIOUS: $(BUILD_DIR)/%.o
