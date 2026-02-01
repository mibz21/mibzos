/*
 * memory_allocator.h
 *
 * This file contains declarations for a simple kernel memory allocator using linked lists.
 */

#ifndef MEMORY_ALLOCATOR_H
#define MEMORY_ALLOCATOR_H

#include <stdalign.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Memory block structure */
typedef struct MemoryBlock {
    size_t size;              /* Size of the block */
    struct MemoryBlock *next; /* Pointer to next block */
    uint8_t free;             /* Is this block free? (1=free, 0=used) */
} MemoryBlock __attribute__((aligned(sizeof(void *))));

_Static_assert(_Alignof(MemoryBlock) == sizeof(void *), "MemoryBlock must be pointer-aligned");

/*
 * ============================================
 * Heap Allocator (kmalloc)
 * ============================================
 */

/* Initialize the memory allocator */
void mem_init(void);

/* Allocate a memory block */
void *kmalloc(size_t size);

/* Free a memory block */
void kfree(void *ptr);

/*
 * ============================================
 * Page Allocator
 * ============================================
 */

/* Initialize page allocator - call before alloc_page() */
void page_alloc_init(void);

/* Allocate one 4KB page */
void *alloc_page(void);

/* Allocate multiple contiguous 4KB pages */
void *alloc_pages(size_t count);

/* Free one page */
void free_page(void *addr);

/* Free multiple contiguous pages */
void free_pages(void *addr, size_t count);

#endif /* MEMORY_ALLOCATOR_H */
