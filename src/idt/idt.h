#ifndef IDT_H
#define IDT_H

#include <stdint.h>

struct idt_desc
{
    uint16_t offset_1; // Ofset bits 0 - 15
    uint16_t selector; // Selector thats in out GDT
    uint8_t zero;      // Does nothing, unused set zero
    uint8_t type_attr; // Descriptor type and attributers
    uint16_t offset_2; // Ofset bits 16-31

} __attribute__((packed));

struct idtr_desc
{
    uint16_t limit; // Size of descriptor table -1
    uint32_t base;  // Base address of the start of the IDT
} __attribute__((packed));

void idt_zero();

void idt_set(int interrupt_no, void *address);

void idt_init();

void enable_interrupts();
void diable_interrupts();

#endif