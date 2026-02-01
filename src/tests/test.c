/*
 * test.c - Kernel test framework implementation
 */

#include "test.h"

#include "uart.h"

#include <stddef.h>
#include <stdint.h>

/* Test registry */
struct test_entry {
    const char *name;
    test_func_t func;
};

static struct test_entry tests[MAX_TESTS];
static uint32_t test_count = 0;

/* Current test state */
static struct test_result current_test;
static bool test_running = false;

/* Global statistics */
static uint32_t total_tests_passed = 0;
static uint32_t total_tests_failed = 0;
static uint32_t total_assertions_passed = 0;
static uint32_t total_assertions_failed = 0;

/*
 * Helper functions for printing
 */

static void print_uint(uint32_t value)
{
    if (value == 0) {
        uart_putc('0');
        return;
    }

    char buf[12]; /* Max uint32_t is 10 digits */
    int i = 0;

    while (value > 0) {
        buf[i++] = '0' + (value % 10);
        value /= 10;
    }

    /* Print in reverse order */
    while (i > 0) {
        uart_putc(buf[--i]);
    }
}

/*
 * Test framework API
 */

void test_init(void)
{
    test_count = 0;
    total_tests_passed = 0;
    total_tests_failed = 0;
    total_assertions_passed = 0;
    total_assertions_failed = 0;

    uart_puts("\n");
    uart_puts("=====================================\n");
    uart_puts("  Kernel Test Framework Initialized\n");
    uart_puts("=====================================\n");
    uart_puts("\n");
}

void test_register(const char *name, test_func_t func)
{
    if (test_count >= MAX_TESTS) {
        uart_puts("ERROR: Too many tests registered!\n");
        return;
    }

    tests[test_count].name = name;
    tests[test_count].func = func;
    test_count++;
}

void test_run_all(void)
{
    uart_puts("Running ");
    print_uint(test_count);
    uart_puts(" test(s)...\n\n");

    for (uint32_t i = 0; i < test_count; i++) {
        /* Initialize current test state */
        current_test.name = tests[i].name;
        current_test.passed = true;
        current_test.assertions_passed = 0;
        current_test.assertions_failed = 0;
        test_running = true;

        /* Print test header */
        uart_puts("[");
        print_uint(i + 1);
        uart_puts("/");
        print_uint(test_count);
        uart_puts("] ");
        uart_puts(tests[i].name);
        uart_puts("...\n");

        /* Run the test */
        tests[i].func();

        /* Update statistics */
        total_assertions_passed += current_test.assertions_passed;
        total_assertions_failed += current_test.assertions_failed;

        if (current_test.passed) {
            total_tests_passed++;
            uart_puts("  [PASS] ");
        } else {
            total_tests_failed++;
            uart_puts("  [FAIL] ");
        }

        print_uint(current_test.assertions_passed);
        uart_puts(" assertion(s) passed");

        if (current_test.assertions_failed > 0) {
            uart_puts(", ");
            print_uint(current_test.assertions_failed);
            uart_puts(" failed");
        }

        uart_puts("\n\n");
        test_running = false;
    }
}

void test_print_summary(void)
{
    uart_puts("=====================================\n");
    uart_puts("  Test Summary\n");
    uart_puts("=====================================\n");

    uart_puts("Tests:      ");
    print_uint(total_tests_passed);
    uart_puts(" passed, ");
    print_uint(total_tests_failed);
    uart_puts(" failed, ");
    print_uint(test_count);
    uart_puts(" total\n");

    uart_puts("Assertions: ");
    print_uint(total_assertions_passed);
    uart_puts(" passed, ");
    print_uint(total_assertions_failed);
    uart_puts(" failed, ");
    print_uint(total_assertions_passed + total_assertions_failed);
    uart_puts(" total\n");

    if (total_tests_failed == 0) {
        uart_puts("\nResult: ALL TESTS PASSED\n");
    } else {
        uart_puts("\nResult: SOME TESTS FAILED\n");
    }

    uart_puts("=====================================\n\n");
}

/*
 * Assertion implementation
 */

void test_assertion_passed(void)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }
    current_test.assertions_passed++;
}

void test_assertion_failed(const char *file, int line, const char *expr)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }

    current_test.assertions_failed++;
    current_test.passed = false;

    uart_puts("  ASSERTION FAILED: ");
    uart_puts(file);
    uart_puts(":");
    print_uint(line);
    uart_puts("\n");
    uart_puts("    Expression: ");
    uart_puts(expr);
    uart_puts("\n");
}

void test_assertion_failed_eq(const char *file, int line, const char *expr_a, const char *expr_b,
                              uint64_t val_a, uint64_t val_b)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }

    current_test.assertions_failed++;
    current_test.passed = false;

    uart_puts("  ASSERTION FAILED: ");
    uart_puts(file);
    uart_puts(":");
    print_uint(line);
    uart_puts("\n");
    uart_puts("    Expected: ");
    uart_puts(expr_a);
    uart_puts(" == ");
    uart_puts(expr_b);
    uart_puts("\n");
    uart_puts("    Actual:   ");
    uart_puthex(val_a);
    uart_puts(" != ");
    uart_puthex(val_b);
    uart_puts("\n");
}

void test_assertion_failed_ne(const char *file, int line, const char *expr_a, const char *expr_b,
                              uint64_t val)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }

    current_test.assertions_failed++;
    current_test.passed = false;

    uart_puts("  ASSERTION FAILED: ");
    uart_puts(file);
    uart_puts(":");
    print_uint(line);
    uart_puts("\n");
    uart_puts("    Expected: ");
    uart_puts(expr_a);
    uart_puts(" != ");
    uart_puts(expr_b);
    uart_puts("\n");
    uart_puts("    Actual:   both equal ");
    uart_puthex(val);
    uart_puts("\n");
}

void test_assertion_failed_null(const char *file, int line, const char *expr, uint64_t val)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }

    current_test.assertions_failed++;
    current_test.passed = false;

    uart_puts("  ASSERTION FAILED: ");
    uart_puts(file);
    uart_puts(":");
    print_uint(line);
    uart_puts("\n");
    uart_puts("    Expected: ");
    uart_puts(expr);
    uart_puts(" == NULL\n");
    uart_puts("    Actual:   ");
    uart_puthex(val);
    uart_puts("\n");
}

void test_assertion_failed_not_null(const char *file, int line, const char *expr)
{
    if (!test_running) {
        uart_puts("ERROR: Assertion outside of test!\n");
        return;
    }

    current_test.assertions_failed++;
    current_test.passed = false;

    uart_puts("  ASSERTION FAILED: ");
    uart_puts(file);
    uart_puts(":");
    print_uint(line);
    uart_puts("\n");
    uart_puts("    Expected: ");
    uart_puts(expr);
    uart_puts(" != NULL\n");
    uart_puts("    Actual:   NULL\n");
}
