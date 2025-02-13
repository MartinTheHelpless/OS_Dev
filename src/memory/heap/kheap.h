#ifndef KHEAP_H
#define KHEAP_H

#include "heap.h"
#include "config.h"
#include "kernel.h"

#include <stdint.h>
#include <stddef.h>

void kheap_init();
void *kmalloc(size_t size);

#endif
