section .asm

extern int21h_handler
extern no_interrupt_handler

global no_interrupt
global idt_load
global int21h

global enable_interrupts
global diable_interrupts

idt_load:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    lidt [ebx]

    pop ebp
    ret

int21h:
    cli
    pushad
    call int21h_handler
    popad
    sti
    iret

no_interrupt:
    cli
    pushad
    call no_interrupt_handler
    popad
    sti
    iret

enable_interrupts:
    sti
    ret

diable_interrupts:
    cli
    ret

