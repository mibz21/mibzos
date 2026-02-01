/*
 * memory_allocator.c
 * Implementation of a simple memory allocator using linked lists.
 */

#include "memory_allocator.h"

#include "uart.h"

static MemoryBlock *block_list_start = NULL;
static uint8_t *heap_start = NULL;
static size_t heap_size = 0;

/*
 * ============================================
 * Page Allocator
 * ============================================
 */

#define PAGE_SIZE 4096
#define RAM_START 0x80000000
#define RAM_END   0x88000000 /* 128 MB of RAM */
#define RAM_SIZE  (RAM_END - RAM_START)
#define MAX_PAGES (RAM_SIZE / PAGE_SIZE) /* 32768 pages total in RAM */

/* Bitmap: 1 bit per page = 32768 bits = 4096 bytes (for maximum possible pages) */
static uint8_t page_bitmap[MAX_PAGES / 8];
static void *page_alloc_start = NULL; /* First page we can allocate */
static size_t num_pages = 0;          /* Actual number of allocatable pages */

/*
 * Helper: Convert page number to physical address
 */
static inline void *page_to_addr(size_t page_num)
{
    return (void *)((uint64_t)page_alloc_start + (page_num * PAGE_SIZE));
}

/*
 * Helper: Convert physical address to page number
 */
static inline size_t addr_to_page(void *addr)
{
    return ((uint64_t)addr - (uint64_t)page_alloc_start) / PAGE_SIZE;
}

/*
 * Helper: Check if a page is free
 */
static inline bool is_page_free(size_t page_num)
{
    size_t byte = page_num / 8;
    size_t bit = page_num % 8;
    return !(page_bitmap[byte] & (1 << bit));
}

/*
 * Helper: Mark a page as used
 */
static inline void mark_page_used(size_t page_num)
{
    size_t byte = page_num / 8;
    size_t bit = page_num % 8;
    page_bitmap[byte] |= (1 << bit);
}

/*
 * Helper: Mark a page as free
 */
static inline void mark_page_free(size_t page_num)
{
    size_t byte = page_num / 8;
    size_t bit = page_num % 8;
    page_bitmap[byte] &= ~(1 << bit);
}

/*
 * Initialize page allocator
 * Call this before using alloc_page() or free_page()
 */
void page_alloc_init(void)
{
    extern char __kernel_end;

    /* Start allocating pages after the kernel */
    page_alloc_start = (void *)&__kernel_end;

    /* Align to page boundary */
    uint64_t addr = (uint64_t)page_alloc_start;
    if (addr % PAGE_SIZE != 0) {
        addr = (addr + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1);
        page_alloc_start = (void *)addr;
    }

    /* Calculate actual number of allocatable pages */
    size_t available_bytes = RAM_END - (uint64_t)page_alloc_start;
    num_pages = available_bytes / PAGE_SIZE;

    /* Clear bitmap (all pages free initially) */
    for (size_t i = 0; i < sizeof(page_bitmap); i++) {
        page_bitmap[i] = 0;
    }

    uart_puts("Page Allocator Initialized!\n");
    uart_puts("  Page size: 4096 bytes\n");
    uart_puts("  Start addr: ");
    uart_puthex((uint64_t)page_alloc_start);
    uart_puts("\n");
    uart_puts("  Available pages: ");
    uart_puthex(num_pages);
    uart_puts("\n");
}

/*
 * Allocate one page (4096 bytes)
 * Returns: pointer to page, or NULL if out of memory
 */
void *alloc_page(void)
{
    /* Find first free page */
    for (size_t i = 0; i < num_pages; i++) {
        if (is_page_free(i)) {
            mark_page_used(i);
            return page_to_addr(i);
        }
    }

    /* Out of memory */
    uart_puts("Page allocation failed - out of memory!\n");
    return NULL;
}

/*
 * Allocate multiple contiguous pages
 * Returns: pointer to first page, or NULL if not enough contiguous pages
 */
void *alloc_pages(size_t count)
{
    if (count == 0) {
        return NULL;
    }

    if (count > num_pages) {
        uart_puts("Page allocation failed - requested more pages than available!\n");
        return NULL;
    }

    /* Find 'count' contiguous free pages */
    for (size_t i = 0; i <= num_pages - count; i++) {
        /* Check if we have 'count' consecutive free pages starting at i */
        bool found = true;
        for (size_t j = 0; j < count; j++) {
            if (!is_page_free(i + j)) {
                found = false;
                break;
            }
        }

        if (found) {
            /* Mark all pages as used */
            for (size_t j = 0; j < count; j++) {
                mark_page_used(i + j);
            }
            return page_to_addr(i);
        }
    }

    /* Not enough contiguous pages */
    uart_puts("Page allocation failed - not enough contiguous pages!\n");
    return NULL;
}

/*
 * Free one page
 */
void free_page(void *addr)
{
    if (addr == NULL) {
        return;
    }

    /* Validate address is within our range */
    if ((uint64_t)addr < (uint64_t)page_alloc_start || (uint64_t)addr >= RAM_END) {
        uart_puts("free_page: invalid address ");
        uart_puthex((uint64_t)addr);
        uart_puts("\n");
        return;
    }

    /* Validate address is page-aligned */
    if ((uint64_t)addr % PAGE_SIZE != 0) {
        uart_puts("free_page: address not page-aligned ");
        uart_puthex((uint64_t)addr);
        uart_puts("\n");
        return;
    }

    size_t page_num = addr_to_page(addr);
    mark_page_free(page_num);
}

/*
 * Free multiple contiguous pages
 */
void free_pages(void *addr, size_t count)
{
    if (addr == NULL || count == 0) {
        return;
    }

    for (size_t i = 0; i < count; i++) {
        void *page = (void *)((uint64_t)addr + (i * PAGE_SIZE));
        free_page(page);
    }
}

/*
 * ============================================
 * Heap Allocator (kmalloc)
 * ============================================
 */

static void coalesce_free_blocks(void)
{
    MemoryBlock *current = block_list_start;

    while (current && current->next) {
        /* Only coalesce if both blocks are free */
        if (current->free && current->next->free) {
            /*
             * Check if blocks are physically adjacent in memory
             *
             * current block:     [header][data..........]
             *                                            ^ current_end
             * next block:                                [header][data...]
             *                                            ^ next_start
             *
             * If current_end == next_start, they're touching!
             */
            void *current_end = (uint8_t *)current + sizeof(MemoryBlock) + current->size;
            void *next_start = (void *)current->next;

            if (current_end == next_start) {
                /* Blocks are adjacent - merge them! */
                current->size += sizeof(MemoryBlock) + current->next->size;
                current->next = current->next->next;

                /* Don't advance current - we might be able to merge with
                 * the new next block too */
            } else {
                /* Blocks are not adjacent (separated by other allocations or pages)
                 * Move to next block */
                current = current->next;
            }
        } else {
            /* At least one block is in use, can't coalesce */
            current = current->next;
        }
    }
}

void mem_init(void)
{
    /* Allocate 4 initial pages */
    heap_start = (void *)alloc_pages(4);
    heap_size = 4 * PAGE_SIZE;

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
            /* Found a free block */
            if (current->size >= size + sizeof(MemoryBlock) + 1) {
                /* Split block */
                MemoryBlock *new_block =
                    (MemoryBlock *)((void *)current + sizeof(MemoryBlock) + size);
                new_block->size = current->size - size - sizeof(MemoryBlock);
                new_block->next = NULL;
                new_block->free = 1;

                current->size = size;
                current->next = new_block;
            }
            current->free = 0;
            return (uint8_t *)current + sizeof(MemoryBlock);
        }
        current = current->next;
    }

    /*
     * Heap exhausted - need to grow it
     *
     * Strategy: Allocate 4 pages (16KB) from the page allocator
     * This gives us room for multiple small allocations before needing more pages
     */
    void *new_pages = alloc_pages(4);
    if (new_pages == NULL) {
        uart_puts("kmalloc: page allocator out of memory!\n");
        return NULL;
    }

    /* Create a new free block spanning the 4 pages */
    MemoryBlock *new_block = (MemoryBlock *)new_pages;
    new_block->size = (4 * PAGE_SIZE) - sizeof(MemoryBlock);
    new_block->free = 1;

    /* Add to start of free list */
    new_block->next = block_list_start;
    block_list_start = new_block;

    /* Try to coalesce with adjacent blocks (if any) */
    coalesce_free_blocks();

    /*
     * Recursive retry: Now that we've added pages, try the allocation again
     *
     * How this works:
     * 1. We just added a large free block (16KB - sizeof(MemoryBlock))
     * 2. The recursive call will search the list again
     * 3. It will find our newly added block (which is free and big enough)
     * 4. It will carve out the requested size from that block
     * 5. The returned memory is CONTIGUOUS (comes from one block)
     *
     * Why recursion instead of a loop?
     * - Cleaner: reuses existing allocation logic
     * - Safe: only recurses once (next call will find the block)
     * - Clear: separates "grow heap" from "allocate from heap"
     */
    return kmalloc(size);
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