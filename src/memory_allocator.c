/*
 * memory_allocator.c
 * Implementation of a simple memory allocator using linked lists.
 */

#include "memory_allocator.h"

#include "uart.h"

/* Forward declaration of uart_puts (defined in kernel.c) */
void uart_puts(const char *s);

static MemoryBlock *block_list_start = NULL;
static uint8_t *heap_start = NULL;
static size_t heap_size = 0;
#define RAM_START 0x80000000
#define RAM_END   0x88000000 /* 128 MB of RAM */

void mem_init(void)
{
    extern char __kernel_end; /* Linker symbol from linker.ld */
    heap_start = (uint8_t *)&__kernel_end;
    heap_size = RAM_END - (size_t)heap_start;

    /* Initialize free list with one big free block */
    block_list_start = (MemoryBlock *)heap_start;
    block_list_start->size = heap_size - sizeof(MemoryBlock);
    block_list_start->next = NULL;
    block_list_start->free = 1;
    uart_puts("Memory Allocator Initialized!\n");
}

void *kmalloc(size_t size)
{
    if (size == 0) {
        return NULL;
    }
    MemoryBlock *current = block_list_start;
    while (current) {
        if (current->free && current->size >= size) {
            /* Check if we have enough space to split the block */
            if (current->size >= size + sizeof(MemoryBlock) + 1) {
                /* Split the block: create a new free block with the remainder */
                MemoryBlock *new_block =
                    (MemoryBlock *)((uint8_t *)current + sizeof(MemoryBlock) + size);
                new_block->size = current->size - size - sizeof(MemoryBlock);
                new_block->next = current->next;
                new_block->free = 1;

                /* Update current block */
                current->free = 0;
                current->size = size;
                current->next = new_block;
            } else {
                /* Not enough space to split - use entire block */
                current->free = 0;
                /* Keep current->size as is (may be larger than requested) */
            }

            return (void *)((uint8_t *)current + sizeof(MemoryBlock));
        }
        current = current->next;
    }
    uart_puts("Memory Allocation Failed!\n");
    return NULL;
}

static void coalesce_free_blocks()
{
    MemoryBlock *current = block_list_start;
    while (current && current->next) {
        if (current->free && current->next->free) {
            current->size += sizeof(MemoryBlock) + current->next->size;
            current->next = current->next->next;
        } else {
            current = current->next;
        }
    }
}

void kfree(void *ptr)
{
    if (ptr == NULL) {
        return;
    }
    MemoryBlock *block = (MemoryBlock *)((uint8_t *)ptr - sizeof(MemoryBlock));
    block->free = 1;
    coalesce_free_blocks();
    return;
}