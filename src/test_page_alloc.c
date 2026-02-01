/*
 * test_page_alloc.c - Page allocator tests
 */

#include "memory_allocator.h"
#include "test.h"

#include <stddef.h>

/*
 * Test: Single page allocation
 */
static void test_single_page_alloc(void)
{
    void *page = alloc_page();
    TEST_ASSERT_NOT_NULL(page);

    /* Page should be 4KB aligned */
    TEST_ASSERT((uint64_t)page % 4096 == 0);

    /* Clean up */
    free_page(page);
}

/*
 * Test: Multiple page allocations
 */
static void test_multiple_page_alloc(void)
{
    void *page1 = alloc_page();
    void *page2 = alloc_page();
    void *page3 = alloc_page();

    TEST_ASSERT_NOT_NULL(page1);
    TEST_ASSERT_NOT_NULL(page2);
    TEST_ASSERT_NOT_NULL(page3);

    /* All should be different */
    TEST_ASSERT_NE(page1, page2);
    TEST_ASSERT_NE(page2, page3);
    TEST_ASSERT_NE(page1, page3);

    /* Clean up */
    free_page(page1);
    free_page(page2);
    free_page(page3);
}

/*
 * Test: Free and reuse page
 */
static void test_free_and_reuse(void)
{
    void *page1 = alloc_page();
    TEST_ASSERT_NOT_NULL(page1);

    /* Free it */
    free_page(page1);

    /* Allocate again - should ideally get same page back */
    void *page2 = alloc_page();
    TEST_ASSERT_NOT_NULL(page2);

    /* Note: We don't guarantee page2 == page1, but it's likely */

    free_page(page2);
}

/*
 * Test: Allocate multiple contiguous pages
 */
static void test_alloc_pages(void)
{
    /* Allocate 4 contiguous pages */
    void *pages = alloc_pages(4);
    TEST_ASSERT_NOT_NULL(pages);

    /* Should be 4KB aligned */
    TEST_ASSERT((uint64_t)pages % 4096 == 0);

    /* Clean up */
    free_pages(pages, 4);
}

/*
 * Test: Free NULL handling
 */
static void test_free_null(void)
{
    /* Should not crash */
    free_page(NULL);
    free_pages(NULL, 5);

    TEST_ASSERT(true); /* If we got here, it didn't crash */
}

/*
 * Test: Page alignment
 */
static void test_page_alignment(void)
{
    /* Allocate several pages and verify all are 4KB aligned */
    void *pages[10];

    for (int i = 0; i < 10; i++) {
        pages[i] = alloc_page();
        TEST_ASSERT_NOT_NULL(pages[i]);
        TEST_ASSERT((uint64_t)pages[i] % 4096 == 0);
    }

    /* Clean up */
    for (int i = 0; i < 10; i++) {
        free_page(pages[i]);
    }
}

/*
 * Register all page allocator tests
 */
void register_page_alloc_tests(void)
{
    test_register("Single page allocation", test_single_page_alloc);
    test_register("Multiple page allocations", test_multiple_page_alloc);
    test_register("Free and reuse page", test_free_and_reuse);
    test_register("Allocate contiguous pages", test_alloc_pages);
    test_register("Free NULL handling", test_free_null);
    test_register("Page alignment", test_page_alignment);
}
