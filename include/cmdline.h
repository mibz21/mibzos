/*
 * cmdline.h - Kernel command-line parsing
 *
 * Parses kernel boot arguments passed via QEMU's -append option.
 * In RISC-V, the bootloader typically passes arguments via registers or DTB.
 * For simplicity, we'll use a hardcoded string that can be overridden.
 */

#ifndef CMDLINE_H
#define CMDLINE_H

#include <stdbool.h>

/*
 * Parse kernel command line and check for flags
 */
void cmdline_init(const char *cmdline);

/*
 * Check if a specific flag is present in the command line
 * Example: cmdline_has_flag("test") checks for "test" or "test=1"
 */
bool cmdline_has_flag(const char *flag);

/*
 * Get the value of a command-line parameter
 * Example: cmdline_get_value("loglevel") for "loglevel=3"
 * Returns NULL if not found
 */
const char *cmdline_get_value(const char *key);

#endif /* CMDLINE_H */
