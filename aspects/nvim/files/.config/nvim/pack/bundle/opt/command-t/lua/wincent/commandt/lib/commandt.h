/**
 * SPDX-FileCopyrightText: Copyright 2021-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef COMMANDT_H
#define COMMANDT_H

#include <stdbool.h> /* for bool */
#include <stddef.h> /* for size_t */
#include <stdint.h> /* for uint32_t */

#include "str.h" /* for str_t */

/**
 *  Represents a single "haystack" (ie. a string to be searched for the needle).
 */
typedef struct {
    str_t *candidate;
    long bitmask;
    float score;
} haystack_t;

/**
 * How a scanner produces its candidates.
 */
typedef enum {
    /**
     * All candidates are present by the time the scanner is returned (the copy,
     * str, file, and synchronous exec scanners). There is nothing to produce.
     */
    SCANNER_EAGER = 0,

    /**
     * Candidates are produced asynchronously by a background thread reading from
     * a child process's stdout (see `commandt_scanner_new_exec_async()`).
     */
    SCANNER_EXEC,
} scanner_kind_t;

typedef struct {
    /**
     * Number of candidates currently stored in the scanner. For async scanners
     * this grows over time and is published/read with release/acquire ordering.
     */
    unsigned count;

    str_t *candidates;

    /**
     * @internal
     *
     * Book-keeping detail, needed for call to `munmap()`.
     */
    ssize_t candidates_size;

    /**
     * @internal
     *
     * Book-keeping detail, needed for call to `munmap()`.
     */
    char *buffer;

    /**
     * @internal
     *
     * Book-keeping detail, needed for call to `munmap()`.
     */
    ssize_t buffer_size;

    /**
     * @internal
     *
     * Maximum number of candidates the scanner may ever hold. Used to size the
     * matcher's `haystacks` slab up front so it never has to move.
     */
    unsigned capacity;

    /**
     * @internal
     *
     * Streaming/async production state. Not read from Lua, but mirrored in the
     * FFI cdef for layout consistency with the other structs.
     */
    int kind; // `scanner_kind_t`.
    int fd; // Read end of the child's stdout pipe, or -1.
    int pid; // Child PID, or -1.
    unsigned drop; // Leading characters to drop from each candidate.
    unsigned max_files; // Cap on candidate count, or 0 for unlimited.
    int done; // Non-zero once production has finished.
    void *thread; // Producer `pthread_t *`, or NULL.
} scanner_t;

// TODO flesh this out; basically make it a container for instance variables
typedef struct {
    /**
     * Note the matcher doesn't take ownership of the `scanner` as these can be
     * expensive to copy or recreate.
     */
    scanner_t *scanner;
    haystack_t *haystacks;

    bool always_show_dot_files;
    bool ignore_case;
    bool ignore_spaces;
    bool never_show_dot_files;
    bool smart_case;
    // bool sort;

    /**
     * Limit the number of returned results. Must be non-zero.
     */
    unsigned limit;
    unsigned threads;

    /**
     * Note that the matcher doesn't take ownership of the `needle` (ie. it
     * doesn't make a copy of it) because it only needs it to stick around long
     * enough to calculate scores with it. These fields are merely here as a
     * convenience for temporarily threading state through to `commandt_score()`
     * and friends.
     */
    const char *needle;
    size_t needle_length;
    long needle_bitmask;

    const char *last_needle;
    size_t last_needle_length;

    /**
     * `haystacks` is a slab sized to the scanner's capacity; `haystacks_size` is
     * its byte size (for `munmap()`) and `initialized` tracks how many entries
     * have been set up so far (the rest are set up lazily as an async scanner
     * streams more candidates in).
     */
    size_t haystacks_size;
    unsigned initialized;
} matcher_t;

typedef struct {
    // Will roll-over in 2038, and as we're only using this for benchmarks, we
    // don't care.
    uint32_t seconds;
    uint32_t microseconds;
} benchmark_t;

/**
 * For benchmarking, returns number of seconds and microseconds since the epoch.
 *
 * Wrapper around `clock_gettime()`, because Lua's own `os.time()` only returns
 * integral numbers of seconds.
 */
benchmark_t commandt_epoch();

/**
 * Return number of processors on the current machine.
 */
unsigned commandt_processors();

#endif
