// kernel.c
void putchar(char c)
{
    volatile char *video = (volatile char *)0xb8000;
    *video = c;
    *(video + 1) = 0x07; // White on black
}

void kernel_main()
{
    char *message = "Hello, OS!";
    while (*message)
    {
        putchar(*message++);
    }
    while (1)
    {
    } // Halt
}
