#include "disk.h"
#include "io/io.h"
#include "config.h"
#include "status.h"
#include "memory/memory.h"

struct disk disk;

int disk_read_sector(int lba, int total, void *buffer)
{
    outb(0x1F6, lba >> 24 | 0xe0);
    outb(0x1F2, total);
    outb(0x1F3, (unsigned char)(lba & 0xff));
    outb(0x1F4, (unsigned char)lba >> 8);
    outb(0x1F5, (unsigned char)lba >> 16);
    outb(0x1F7, 0x20);

    unsigned short *ptr = (unsigned short *)buffer;
    for (int b = 0; b < total; ++b)
    {
        char c = insb(0x1F7);
        while (!(c & 0x08))
            c = insb(0x1F7);

        for (int i = 0; i < 256; ++i, ++ptr)
            *ptr = insw(0x1F0);
    }

    return 0;
}

void disk_search_and_init()
{
    memset(&disk, 0, sizeof(disk));
    disk.type = OS_DISK_TYPE_REAL;
    disk.sector_size = OS_SECTOR_SIZE;
}

struct disk *disk_get(int index)
{
    if (index == 0)
        return &disk;

    return 0;
}

int disk_read_block(struct disk *idisk, unsigned int lba, int total, void *buffer)
{
    if (idisk != &disk)
        return -EIO;

    return disk_read_sector(lba, total, buffer);
}