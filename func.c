#include <stdint.h>

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
volatile unsigned short *video_memory = (unsigned short *)0xB8000;
int cursor_x = 0;
int cursor_y = 0;

void clear_screen()
{
    for (int y = 0; y < VGA_HEIGHT; y++)
    {
        for (int x = 0; x < VGA_WIDTH; x++)
        {
            video_memory[y * VGA_WIDTH + x] = (0x07 << 8) | ' ';
        }
    }
    cursor_x = 0;
    cursor_y = 0;
}

void print_char(char c)
{
    if (c == '\n')
    {
        cursor_x = 0;
        cursor_y++;
    }
    else
    {
        video_memory[cursor_y * VGA_WIDTH + cursor_x] = (0x07 << 8) | c;
        cursor_x++;
        if (cursor_x >= VGA_WIDTH)
        {
            cursor_x = 0;
            cursor_y++;
        }
    }
}

uint8_t inb(uint16_t port)
{
    uint8_t result;
    __asm__ volatile("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

char get_key()
{
    char c = 0;
    while ((c = inb(0x60)) == 0)
        ;
    return c;
}