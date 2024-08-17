ORG 0x7C00
BITS 16

main:
    xor ax,ax
    mov ds,ax
    mov es,ax
    mov ss, ax
    mov sp, 0x7C00
    call print_message
    hlt

halt:
    jmp halt

print_message:
    push si
    push ax
    push bx
    mov si, message
    call print_loop
    ret


print_loop:
    lodsb
    or al,al
    jz done_print
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print_loop

done_print:
    pop ax
    pop bx
    pop si
    ret

message: DB 'This is a message from the bootloader', 0x0D, 0x0A, 0

times 510-($-$$) db 0
DW 0AA55h