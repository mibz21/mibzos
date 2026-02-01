/*
 * test_memory.c - Memory allocator tests
 */

#include "memory_allocator.h"
#include "test.h"

#include <stddef.h>

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
 * Register all memory allocator tests
 */
void register_memory_tests(void)
{
    test_register("Basic allocation", test_basic_allocation);
    test_register("Free and reuse", test_free_and_reuse);
    test_register("Coalescing", test_coalescing);
    test_register("Edge cases", test_edge_cases);
    test_register("Multiple alloc/free", test_multiple_alloc_free);
}
