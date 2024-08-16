#include <stdint.h>

// Define the VGA text mode color codes
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_ADDR 0xb8000
#define VGA_COLOR_WHITE 0x07

// VGA buffer
volatile uint16_t *vga_buffer = (uint16_t *)VGA_ADDR;
uint8_t cursor_x = 0;
uint8_t cursor_y = 0;

void put_char_at(uint8_t x, uint8_t y, char c, uint8_t color)
{
    if (x >= VGA_WIDTH || y >= VGA_HEIGHT)
        return;
    vga_buffer[y * VGA_WIDTH + x] = (color << 8) | c;
}

void print(const char *str)
{
    while (*str)
    {
        if (*str == '\n')
        {
            cursor_x = 0;
            if (++cursor_y >= VGA_HEIGHT)
                cursor_y = 0;
        }
        else
        {
            put_char_at(cursor_x, cursor_y, *str, VGA_COLOR_WHITE);
            if (++cursor_x >= VGA_WIDTH)
            {
                cursor_x = 0;
                if (++cursor_y >= VGA_HEIGHT)
                    cursor_y = 0;
            }
        }
        str++;
    }
}

void kernel_entry()
{
    print("Hello, World from 64-bit kernel!");
    while (1)
        ; // Halt the CPU
}
