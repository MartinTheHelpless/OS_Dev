[BITS 16]               ; 16-bit mode
[ORG 0x7C00]            ; Origin at the BIOS load address

start:
    ; Set up stack
    mov ax, 0x07C0
    add ax, 0x0200
    mov ss, ax
    mov sp, 0x7BFF

    ; Print "Booting kernel..." message
    mov si, msg
    call print_string

    ; Load the kernel
    mov ax, 0x1000       ; Kernel load address
    mov es, ax
    xor bx, bx           ; ES:BX = 0x100000
    mov ah, 0x02         ; BIOS disk read function
    mov al, 4            ; Read 4 sectors
    mov ch, 0            ; Cylinder 0
    mov cl, 2            ; Start reading from sector 2
    mov dh, 0            ; Head 0
    mov dl, 0x80         ; Drive 0 (first hard disk)
    int 0x13             ; Call BIOS interrupt

    jc load_failed       ; Jump if carry flag is set (error)

    ; Print success message before jumping
    mov si, load_success_msg
    call print_string

    ; Switch to 32-bit protected mode
    cli
    mov eax, cr0
    or eax, 0x1          ; Set PE (Protection Enable) bit
    mov cr0, eax
    jmp 0x08:protected_mode_entry

protected_mode_entry:
    ; Set up 32-bit segment registers
    mov ax, 0x10         ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enable long mode
    mov eax, cr4
    or eax, 0x20         ; Set PAE bit
    mov cr4, eax

    ; Enable long mode
    mov eax, cr0
    or eax, 0x80000000   ; Set the PE bit
    mov cr0, eax

    ; 64-bit mode transition
    jmp 0x08:long_mode_entry

long_mode_entry:
    ; Set up 64-bit mode
    mov eax, 0xC0000080   ; MSR for 64-bit mode
    rdmsr
    or eax, 0x01
    wrmsr

    ; Load the 64-bit kernel
    mov rax, 0x1000      ; Kernel base address (64-bit)
    jmp rax              ; Jump to the 64-bit kernel entry

load_failed:
    ; Print failure message and hang
    mov si, load_fail_msg
    call print_string
    jmp $

print_string:
    mov ah, 0x0E         ; Teletype output function
.next_char:
    lodsb                ; Load byte from DS:SI into AL
    cmp al, 0            ; Compare with null terminator
    je .done             ; If null, we're done
    int 0x10             ; Otherwise, print the character
    jmp .next_char
.done:
    ret

msg db 'Booting kernel...', 0
load_fail_msg db 'Failed to load kernel', 0
load_success_msg db 'Kernel loaded successfully!', 0

; GDT Descriptor
gdt_start:
    dw 0x0000            ; Limit (15:0)
    dw 0x0000            ; Base (15:0)
    db 0x00              ; Base (23:16)
    db 0x9A              ; Access byte (code, execute, readable)
    db 0xCF              ; Flags (16-bit, 64-bit)
    db 0x00              ; Base (31:24)

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Limit (15:0)
    dw gdt_start                ; Base (15:0)

gdt_end:

times 510-($-$$) db 0    ; Fill to 510 bytes
dw 0xAA55                ; Boot signature
