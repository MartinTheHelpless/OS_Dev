all:
	nasm -f bin boot.asm -o OS_Compiled/boot.o
	gcc -m32 -ffreestanding -O2 -Wall -Wextra -c kernel.c -o OS_Compiled/kernel.o
	gcc -T linker.ld -o OS_Compiled/kernel.bin -m32 -ffreestanding -nostdlib OS_Compiled/kernel.o
	cat OS_Compiled/boot.o OS_Compiled/kernel.bin > OS_Compiled/os-image.bin
	mkdir -p OS_Compiled/boot/grub
	cp OS_Compiled/os-image.bin OS_Compiled/boot/kernel.bin
	cp grub.cfg OS_Compiled/boot/grub/grub.cfg
	grub-mkrescue -o os-image.iso OS_Compiled
