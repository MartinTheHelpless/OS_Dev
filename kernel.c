// kernel.c

void clear_screen()
{
    char *video_memory = (char *)0xB8000;
    for (int i = 0; i < 80 * 25 * 2; i++)
    {
        video_memory[i] = 0;
    }
}

void print_char(char c, int col, int row)
{
    unsigned char *video_memory = (unsigned char *)0xB8000;
    int position = (row * 80 + col) * 2;
    video_memory[position] = c;
    video_memory[position + 1] = 0x07; // Attribute byte
}

void kernel_main()
{
    clear_screen();
    print_char('H', 0, 0);
    print_char('e', 1, 0);
    print_char('l', 2, 0);
    print_char('l', 3, 0);
    print_char('o', 4, 0);
    print_char('!', 5, 0);

    while (1)
        ;
}
