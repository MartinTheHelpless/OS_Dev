#include "kernel.h"
#include "idt/idt.h"
#include "io/io.h"
#include "memory/heap/kheap.h"
#include "memory/paging/paging.h"

uint16_t *video_mem = 0;

uint16_t terminal_pos = 0;

static struct paging_4gb_chunk *kernel_chunk = NULL;

void kernel_main()
{
    video_mem = (uint16_t *)0xB8000;

    init_terminal();

    print("Hello World!\n");

    kheap_init();

    idt_init();

    kernel_chunk = paging_new_4gb(PAGING_IS_WRITABLE | PAGING_IS_PRESENT | PAGING_ACCESS_FROM_ALL);

    paging_switch(paging_4gb_chunk_get_directory(kernel_chunk));

    enable_paging();

    enable_interrupts();
}

void init_terminal()
{
    for (size_t i = 0; i < VGA_HEIGHT; i++)
        for (size_t j = 0; j < VGA_WIDTH; j++)
            video_mem[(i * VGA_WIDTH) + j] = CONVERT_CHAR_COLOR(' ', 0);
}

void print(const char *message)
{
    terminal_write_message(message, 15);
}

void terminal_write_character(const char c, int color)
{
    if (c == '\n')
    {
        terminal_pos += VGA_WIDTH - (terminal_pos % VGA_WIDTH);
        return;
    }

    if (terminal_pos >= VGA_HEIGHT * VGA_WIDTH)
        terminal_pos = 0;

    video_mem[terminal_pos++] = CONVERT_CHAR_COLOR(c, 15);
}

void terminal_write_message(const char *message, int color)
{
    for (size_t i = 0; message[i] != 0; i++)
        terminal_write_character(message[i], 15);
}

void terminal_put_character(const char c, int color, int position)
{
    if (c == '\n')
    {
        terminal_pos += VGA_WIDTH - (terminal_pos % VGA_WIDTH);
        return;
    }

    if (terminal_pos >= VGA_HEIGHT * VGA_WIDTH)
        terminal_pos = 0;

    video_mem[position] = CONVERT_CHAR_COLOR(c, 15);
}

void terminal_put_message(const char *message, int color, int position)
{
    for (size_t i = 0; message[i] != 0; i++)
        terminal_put_character(message[i], 15, position + i);
}
