/**
 * SPDX-FileCopyrightText: Copyright 2021-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef SCANNER_H
#define SCANNER_H

#include "commandt.h" /* for scanner_t */
#include "str.h" /* for str_t */

// Define short names for convenience, but all external symbols need prefixes.
#define scanner_new_copy commandt_scanner_new_copy
#define scanner_new_str commandt_scanner_new_str
#define scanner_new commandt_scanner_new
#define scanner_dump commandt_scanner_dump
#define scanner_free commandt_scanner_free

// This one is special: ideally, the underlying symbol would be
// `commandt_scanner_new_exec()`, but I don't want to break userspace (see the
// note in lib.lua), so it keeps its old name.
#define scanner_new_exec commandt_scanner_new_command

/**
 * Create a new `scanner_t` struct initialized with `candidates`.
 *
 * Copies are made of `candidates`. The caller should call `scanner_free()` when
 * done.
 */
scanner_t *scanner_new_copy(const char **candidates, unsigned count);

/**
 * Create a new `scanner_t` struct that will be populated by `execl()`-ing the
 * NUL-terminated `command` string.
 *
 * The `drop` parameter indicates how many characters of prefix, if any, should
 * be omitted from the strings returned by the scanner; commonly, this will be
 * 0, but for commands such as `find .` which prefix all paths with "./", `drop`
 * would be 2.
 */
scanner_t *scanner_new_exec(const char *command, unsigned drop, unsigned max_files);

/**
 * Create a new `scanner_t` struct initialized with `candidates` provided by
 * the caller.
 *
 * Does not take ownership of the memory (the caller is responsible for keeping
 * the `candidates` memory alive and freeing it).
 */
scanner_t *scanner_new_str(str_t *candidates, unsigned count);

/**
 * Create a `scanner_t` struct initialized with the provide values.
 *
 * This is a low-level counterpart to `scanner_new_str`; like that function,
 * this one does not make copies of the provided values but note that _unlike_
 * `scanner_new_str`, it _does_ take ownership of them.
 */
scanner_t *scanner_new(
    unsigned count,
    str_t *candidates,
    size_t candidates_size,
    char *buffer,
    size_t buffer_size
);

/**
 * For debugging, a human-readable string representation of the scanner.
 *
 * Caller should call `str_free()` on the returned string.
 *
 * @internal
 */
str_t *scanner_dump(scanner_t *scanner);

/**
 * Frees a previously created `scanner_t` structure.
 */
void scanner_free(scanner_t *scanner);

#endif
