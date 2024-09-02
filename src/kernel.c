#include "kernel.h"

uint16_t *video_mem = 0;

uint16_t terminal_pos = 0;

void kernel_main()
{
    video_mem = (uint16_t *)0xB8000;

    init_terminal();

    print("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nCurabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.\n\nFusce convallis, mauris imperdiet gravida bibendum, nisl turpis suscipit mauris, sit amet tincidunt sapien nunc nec nisi. Integer ac quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam _________");
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