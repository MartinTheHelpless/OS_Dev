; boot.asm

[org 0x7C00]                  ; Bootloader start at memory location 0x7C00
mov bx, 0x0000                ; Set video segment
mov es, bx
mov ds, bx

mov si, welcome_msg
call print_string

; Load kernel to 0x1000
mov bx, 0x1000                ; Kernel load address
mov dh, 1                     ; Number of sectors to read
mov dl, 0x80                  ; Drive number (0x80 for hard disk)
mov ch, 0                     ; Cylinder
mov cl, 2                     ; Sector number (start from 1, not 0)
mov ah, 0x02                  ; BIOS read sectors function
int 0x13                      ; Call BIOS

; Jump to kernel
jmp 0x1000:0000

jmp $

print_string:
    mov ah, 0x0E
.repeat:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .repeat
.done:
    ret

welcome_msg db 'Booting My Simple OS...', 0

times 510-($-$$) db 0         ; Fill the rest with zeros
dw 0xAA55                     ; Boot signature
