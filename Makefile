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
DRIVERS_DIR = $(SRC_DIR)/drivers
TESTS_DIR = $(SRC_DIR)/tests
BUILD_DIR = build
INCLUDE_DIR = include

# Compiler flags
CFLAGS = -Wall -Wextra -O2 -g
CFLAGS += -I$(INCLUDE_DIR)     # Include header files
CFLAGS += -ffreestanding       # No standard library
CFLAGS += -nostdlib            # Don't link standard library
CFLAGS += -march=rv64gc        # RISC-V 64-bit with extensions
CFLAGS += -mabi=lp64d          # ABI: Long and Pointer are 64-bit, Double FP
CFLAGS += -mcmodel=medany      # Code model for position-independent code

# Linker flags
LDFLAGS = -nostdlib -T $(SRC_DIR)/linker.ld

# Source files (automatically find all .S and .c files)
ASM_SOURCES = $(wildcard $(SRC_DIR)/*.S)
KERNEL_C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
DRIVER_SOURCES = $(wildcard $(DRIVERS_DIR)/*.c)
TEST_SOURCES = $(wildcard $(TESTS_DIR)/*.c)
C_SOURCES = $(KERNEL_C_SOURCES) $(DRIVER_SOURCES) $(TEST_SOURCES)

# Object files (convert source paths to object paths)
ASM_OBJECTS = $(patsubst $(SRC_DIR)/%.S,$(BUILD_DIR)/%.o,$(ASM_SOURCES))
KERNEL_OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(KERNEL_C_SOURCES))
DRIVER_OBJECTS = $(patsubst $(DRIVERS_DIR)/%.c,$(BUILD_DIR)/drivers_%.o,$(DRIVER_SOURCES))
TEST_OBJECTS = $(patsubst $(TESTS_DIR)/%.c,$(BUILD_DIR)/tests_%.o,$(TEST_SOURCES))
C_OBJECTS = $(KERNEL_OBJECTS) $(DRIVER_OBJECTS) $(TEST_OBJECTS)
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

# Compile kernel C files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Compile driver C files
$(BUILD_DIR)/drivers_%.o: $(DRIVERS_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling driver $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Compile test C files
$(BUILD_DIR)/tests_%.o: $(TESTS_DIR)/%.c | $(BUILD_DIR)
	@echo "Compiling test $<..."
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

# Format source code
format:
	@echo "Formatting source code..."
	clang-format -i $(C_SOURCES)
	@echo "Formatting complete!"

# Check formatting (non-destructive)
format-check:
	@echo "Checking code formatting..."
	@clang-format --dry-run --Werror $(C_SOURCES) && echo "  ✓ All files are properly formatted" || \
		(echo "  ✗ Some files need formatting. Run 'make format' to fix." && exit 1)

# Phony targets (not actual files)
.PHONY: all run debug clean info format format-check

# Keep intermediate files
.PRECIOUS: $(BUILD_DIR)/%.o
