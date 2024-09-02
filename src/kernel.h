#include <stdint.h>
#include <stddef.h>

#ifndef KERNEL_H
#define KERNEL_H

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define CONVERT_CHAR_COLOR(character, color) (color << 8 | character)

#define TERMINAL_POS(x, y) (x + y * VGA_WIDTH)

void kernel_main();

void init_terminal();

void print(const char *message);

void terminal_write_character(const char c, int color);

void terminal_write_message(const char *message, int color);

void terminal_put_character(const char c, int color, int position);

void terminal_put_message(const char *message, int color, int position);

#endif