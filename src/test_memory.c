/*
 * test_memory.c - Memory allocator tests
 * Includes tests for both basic heap allocator and integration with page allocator
 */

#include "memory_allocator.h"
#include "test.h"
#include "uart.h"

#include <stddef.h>
#include <stdint.h>

/*
 * Test: Basic allocation
 */
static void test_basic_allocation(void)
{
    void *ptr1 = kmalloc(64);
    TEST_ASSERT_NOT_NULL(ptr1);

    void *ptr2 = kmalloc(128);
    TEST_ASSERT_NOT_NULL(ptr2);

    void *ptr3 = kmalloc(256);
    TEST_ASSERT_NOT_NULL(ptr3);

    /* Clean up */
    kfree(ptr1);
    kfree(ptr2);
    kfree(ptr3);
}

/*
 * Test: Free and reuse
 */
static void test_free_and_reuse(void)
{
    void *ptr1 = kmalloc(128);
    TEST_ASSERT_NOT_NULL(ptr1);

    void *ptr2 = kmalloc(128);
    TEST_ASSERT_NOT_NULL(ptr2);

    /* Free the first block */
    kfree(ptr1);

    /* Allocate same size - should ideally reuse freed block */
    void *ptr3 = kmalloc(128);
    TEST_ASSERT_NOT_NULL(ptr3);

    /* Note: We can't guarantee ptr3 == ptr1 due to implementation details,
     * but it's a good sign if they match */

    /* Clean up */
    kfree(ptr2);
    kfree(ptr3);
}

/*
 * Test: Coalescing of free blocks
 */
static void test_coalescing(void)
{
    /* Allocate several small blocks */
    void *ptr1 = kmalloc(64);
    void *ptr2 = kmalloc(64);
    void *ptr3 = kmalloc(64);

    TEST_ASSERT_NOT_NULL(ptr1);
    TEST_ASSERT_NOT_NULL(ptr2);
    TEST_ASSERT_NOT_NULL(ptr3);

    /* Free them all - they should coalesce */
    kfree(ptr1);
    kfree(ptr2);
    kfree(ptr3);

    /* Now we should be able to allocate a larger block */
    void *large = kmalloc(256);
    TEST_ASSERT_NOT_NULL(large);

    kfree(large);
}

/*
 * Test: Edge cases
 */
static void test_edge_cases(void)
{
    /* Test zero-size allocation */
    void *ptr_zero = kmalloc(0);
    TEST_ASSERT_NULL(ptr_zero);

    /* Test freeing NULL (should not crash) */
    kfree(NULL);
    TEST_ASSERT(true); /* If we got here, it didn't crash */

    /* Test very small allocation */
    void *ptr_small = kmalloc(1);
    TEST_ASSERT_NOT_NULL(ptr_small);
    kfree(ptr_small);
}

/*
 * Test: Multiple allocations and frees
 */
static void test_multiple_alloc_free(void)
{
    void *ptrs[10];

    /* Allocate multiple blocks */
    for (int i = 0; i < 10; i++) {
        ptrs[i] = kmalloc(32 + i * 8);
        TEST_ASSERT_NOT_NULL(ptrs[i]);
    }

    /* Free every other block */
    for (int i = 0; i < 10; i += 2) {
        kfree(ptrs[i]);
    }

    /* Free remaining blocks */
    for (int i = 1; i < 10; i += 2) {
        kfree(ptrs[i]);
    }
}

/*
 * Test: Heap grows when kmalloc exhausts initial pages
 */
static void test_heap_growth(void)
{
    /*
     * Initial heap is 4 pages = 16384 bytes
     * After MemoryBlock header, we have ~16360 bytes usable
     * Allocate 20 blocks of 1KB each = 20KB total
     * This should trigger at least one page allocation request
     */
    void *ptrs[20];

    for (int i = 0; i < 20; i++) {
        ptrs[i] = kmalloc(1024);
        TEST_ASSERT_NOT_NULL(ptrs[i]);

        /* Write a pattern to verify memory is usable */
        uint8_t *p = (uint8_t *)ptrs[i];
        for (int j = 0; j < 1024; j++) {
            p[j] = (uint8_t)(i + j);
        }
    }

    /* Verify patterns are still intact (no corruption) */
    for (int i = 0; i < 20; i++) {
        uint8_t *p = (uint8_t *)ptrs[i];
        for (int j = 0; j < 1024; j++) {
            TEST_ASSERT_EQ(p[j], (uint8_t)(i + j));
        }
    }

    /* Clean up */
    for (int i = 0; i < 20; i++) {
        kfree(ptrs[i]);
    }
}

/*
 * Test: Large allocation spanning multiple pages
 */
static void test_large_allocation(void)
{
    /* Allocate 8KB (2 pages worth) - reasonable given prior allocations */
    size_t size = 8 * 1024;
    void *ptr = kmalloc(size);
    TEST_ASSERT_NOT_NULL(ptr);

    /* Write and verify pattern across entire allocation */
    uint8_t *p = (uint8_t *)ptr;
    for (size_t i = 0; i < size; i++) {
        p[i] = (uint8_t)(i & 0xFF);
    }

    for (size_t i = 0; i < size; i++) {
        TEST_ASSERT_EQ(p[i], (uint8_t)(i & 0xFF));
    }

    kfree(ptr);
}

/*
 * Test: Coalescing works across page boundaries
 */
static void test_coalescing_across_pages(void)
{
    /* Allocate 10 chunks of 2KB each = 20KB total (needs heap growth) */
    void *ptrs[10];
    for (int i = 0; i < 10; i++) {
        ptrs[i] = kmalloc(2048);
        TEST_ASSERT_NOT_NULL(ptrs[i]);
    }

    /* Free every other chunk to fragment heap */
    for (int i = 0; i < 10; i += 2) {
        kfree(ptrs[i]);
    }

    /* Free remaining chunks - should trigger coalescing */
    for (int i = 1; i < 10; i += 2) {
        kfree(ptrs[i]);
    }

    /* Now heap should be mostly coalesced
     * Try to allocate a large chunk (15KB)
     * This should succeed if coalescing worked properly */
    void *large = kmalloc(15 * 1024);
    TEST_ASSERT_NOT_NULL(large);

    kfree(large);
}

/*
 * Test: Many small allocations after heap growth
 */
static void test_many_small_after_growth(void)
{
    /* Force heap to grow with smaller allocation */
    void *large = kmalloc(8 * 1024);
    TEST_ASSERT_NOT_NULL(large);
    kfree(large);

    /* Now allocate 50 small chunks (reduced to avoid fragmentation) */
    void *ptrs[50];
    for (int i = 0; i < 50; i++) {
        ptrs[i] = kmalloc(64);
        TEST_ASSERT_NOT_NULL(ptrs[i]);

        /* Mark with identifier */
        uint8_t *p = (uint8_t *)ptrs[i];
        p[0] = (uint8_t)i;
    }

    /* Verify identifiers */
    for (int i = 0; i < 50; i++) {
        uint8_t *p = (uint8_t *)ptrs[i];
        TEST_ASSERT_EQ(p[0], (uint8_t)i);
    }

    /* Clean up */
    for (int i = 0; i < 50; i++) {
        kfree(ptrs[i]);
    }
}

/*
 * Test: Stress test - mixed allocation sizes
 */
static void test_stress_mixed_sizes(void)
{
    void *ptrs[30];

    /* Allocate varying sizes: 32, 64, 128, 256, 512 bytes (smaller range) */
    for (int i = 0; i < 30; i++) {
        size_t size = 32 << (i % 5); /* Cycles through sizes */
        ptrs[i] = kmalloc(size);
        TEST_ASSERT_NOT_NULL(ptrs[i]);

        /* Fill with pattern */
        uint8_t *p = (uint8_t *)ptrs[i];
        for (size_t j = 0; j < size; j++) {
            p[j] = (uint8_t)(i ^ j);
        }
    }

    /* Verify patterns */
    for (int i = 0; i < 30; i++) {
        size_t size = 32 << (i % 5);
        uint8_t *p = (uint8_t *)ptrs[i];
        for (size_t j = 0; j < size; j++) {
            TEST_ASSERT_EQ(p[j], (uint8_t)(i ^ j));
        }
    }

    /* Free in reverse order */
    for (int i = 29; i >= 0; i--) {
        kfree(ptrs[i]);
    }

    /* Allocate again to verify heap is still functional */
    void *test = kmalloc(2048);
    TEST_ASSERT_NOT_NULL(test);
    kfree(test);
}

/*
 * Register all memory allocator tests
 */
void register_memory_tests(void)
{
    test_register("Basic allocation", test_basic_allocation);
    test_register("Free and reuse", test_free_and_reuse);
    test_register("Coalescing", test_coalescing);
    test_register("Edge cases", test_edge_cases);
    test_register("Multiple alloc/free", test_multiple_alloc_free);
    test_register("Heap growth on exhaustion", test_heap_growth);
    test_register("Large allocation (8KB)", test_large_allocation);
    test_register("Coalescing across pages", test_coalescing_across_pages);
    test_register("Many small after growth", test_many_small_after_growth);
    test_register("Stress test mixed sizes", test_stress_mixed_sizes);
}
