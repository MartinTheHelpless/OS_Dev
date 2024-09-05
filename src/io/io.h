#ifndef IO_h
#define IO_H

unsigned char insb(unsigned short port);
unsigned char insw(unsigned short port);

unsigned char outb(unsigned short port, unsigned char val);
unsigned char outw(unsigned short port, unsigned short val);

#endif