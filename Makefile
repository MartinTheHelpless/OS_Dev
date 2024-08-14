# Compiler and flags
AS=nasm
CC=gcc
CFLAGS=-ffreestanding -O2 -nostdlib
LDFLAGS=-ffreestanding -nostdlib

# Output directory
OUTDIR=OS_Compiled

# Default target
all: $(OUTDIR)/os-image.iso

# Create output directory
$(OUTDIR):
	mkdir -p $(OUTDIR)

# Assemble the bootloader
$(OUTDIR)/bootloader.bin: boot.asm | $(OUTDIR)
	$(AS) -f bin boot.asm -o $(OUTDIR)/bootloader.bin

# Compile the kernel
$(OUTDIR)/kernel.o: kernel.c | $(OUTDIR)
	$(CC) $(CFLAGS) -c kernel.c -o $(OUTDIR)/kernel.o

# Link the kernel
$(OUTDIR)/kernel.bin: $(OUTDIR)/kernel.o | $(OUTDIR)
	$(CC) -Ttext 0x1000 -o $(OUTDIR)/kernel.bin $(LDFLAGS) $(OUTDIR)/kernel.o

# Combine bootloader and kernel
$(OUTDIR)/os-image.bin: $(OUTDIR)/bootloader.bin $(OUTDIR)/kernel.bin | $(OUTDIR)
	cat $(OUTDIR)/bootloader.bin $(OUTDIR)/kernel.bin > $(OUTDIR)/os-image.bin

# Create ISO image
$(OUTDIR)/os-image.iso: $(OUTDIR)/os-image.bin | $(OUTDIR)
	mkdir -p $(OUTDIR)/boot/grub
	cp $(OUTDIR)/os-image.bin $(OUTDIR)/boot/kernel.bin
	cp grub.cfg $(OUTDIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(OUTDIR)/os-image.iso $(OUTDIR)

# Clean up
clean:
	rm -rf $(OUTDIR) os-image.iso

.PHONY: all clean
