; boot.asm
BITS 16
ORG 0x7C00

; Set up segment registers
MOV AX, 0x1000
MOV DS, AX
MOV ES, AX

; Load the kernel (assuming it starts at sector 2)
MOV AH, 0x02          ; BIOS read sectors function
MOV AL, 1             ; Number of sectors to read
MOV CH, 0             ; Cylinder 0
MOV CL, 2             ; Sector 2 (after the bootloader)
MOV DH, 0             ; Head 0
MOV DL, 0x80          ; Drive 0x80 (first hard disk)
INT 0x13              ; Call BIOS interrupt

; Jump to the kernel (0x1000:0000)
JMP 0x1000:0000

; Fill the remaining space with zeros
TIMES 510 - ($ - $$) DB 0

; Boot signature
DW 0xAA55
