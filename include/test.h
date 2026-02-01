/*
 * test.h - Kernel test framework
 *
 * Provides a simple testing infrastructure for kernel code:
 * - Test registration and execution
 * - Assertion macros with reporting
 * - Test statistics and summary
 */

#ifndef TEST_H
#define TEST_H

#include <stdbool.h>
#include <stdint.h>

/* Maximum number of tests that can be registered */
#define MAX_TESTS 64

/* Test function signature */
typedef void (*test_func_t)(void);

/* Test result structure */
struct test_result {
    const char *name;
    bool passed;
    uint32_t assertions_passed;
    uint32_t assertions_failed;
};

/*
 * Test framework API
 */

/* Initialize the test framework */
void test_init(void);

/* Register a test to be run */
void test_register(const char *name, test_func_t func);

/* Run all registered tests */
void test_run_all(void);

/* Get test results summary */
void test_print_summary(void);

/*
 * Test suite registration functions
 */
void register_memory_tests(void);

/*
 * Assertion macros for tests
 */

/* Assert that condition is true */
#define TEST_ASSERT(cond)                                                      \
    do {                                                                       \
        if (cond) {                                                            \
            test_assertion_passed();                                           \
        } else {                                                               \
            test_assertion_failed(__FILE__, __LINE__, #cond);                  \
        }                                                                      \
    } while (0)

/* Assert that two values are equal */
#define TEST_ASSERT_EQ(a, b)                                                   \
    do {                                                                       \
        if ((a) == (b)) {                                                      \
            test_assertion_passed();                                           \
        } else {                                                               \
            test_assertion_failed_eq(__FILE__, __LINE__, #a, #b, (uint64_t)(a), \
                                     (uint64_t)(b));                           \
        }                                                                      \
    } while (0)

/* Assert that two values are not equal */
#define TEST_ASSERT_NE(a, b)                                                   \
    do {                                                                       \
        if ((a) != (b)) {                                                      \
            test_assertion_passed();                                           \
        } else {                                                               \
            test_assertion_failed_ne(__FILE__, __LINE__, #a, #b, (uint64_t)(a)); \
        }                                                                      \
    } while (0)

/* Assert that pointer is NULL */
#define TEST_ASSERT_NULL(ptr)                                                  \
    do {                                                                       \
        if ((ptr) == NULL) {                                                   \
            test_assertion_passed();                                           \
        } else {                                                               \
            test_assertion_failed_null(__FILE__, __LINE__, #ptr, (uint64_t)(ptr)); \
        }                                                                      \
    } while (0)

/* Assert that pointer is not NULL */
#define TEST_ASSERT_NOT_NULL(ptr)                                              \
    do {                                                                       \
        if ((ptr) != NULL) {                                                   \
            test_assertion_passed();                                           \
        } else {                                                               \
            test_assertion_failed_not_null(__FILE__, __LINE__, #ptr);          \
        }                                                                      \
    } while (0)

/*
 * Internal functions (used by macros, don't call directly)
 */
void test_assertion_passed(void);
void test_assertion_failed(const char *file, int line, const char *expr);
void test_assertion_failed_eq(const char *file, int line, const char *expr_a,
                               const char *expr_b, uint64_t val_a,
                               uint64_t val_b);
void test_assertion_failed_ne(const char *file, int line, const char *expr_a,
                               const char *expr_b, uint64_t val);
void test_assertion_failed_null(const char *file, int line, const char *expr,
                                 uint64_t val);
void test_assertion_failed_not_null(const char *file, int line,
                                     const char *expr);

#endif /* TEST_H */
