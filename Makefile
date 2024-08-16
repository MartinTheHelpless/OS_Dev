# Makefile

all: boot.bin kernel.bin

# Build the bootloader
boot.bin: boot.asm
	nasm -f bin -o boot.bin boot.asm

# Build the kernel
kernel.bin: kernel.o
	ld -o kernel.bin -T linker.ld kernel.o

kernel.o: kernel.c
	gcc -ffreestanding -nostdlib -c -o kernel.o kernel.c

clean:
	rm -f *.bin *.o
