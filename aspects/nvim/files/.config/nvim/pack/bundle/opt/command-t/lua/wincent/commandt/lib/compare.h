/**
 * SPDX-FileCopyrightText: Copyright 2010-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

/**
 * @file
 *
 * Haystack ordering comparators.
 *
 * These are defined `static inline` in a header (rather than in a `.c` file) so
 * that the compiler can inline them into hot callers: `heap.c` calls
 * `commandt_cmp_score()` on every insert and extract, and matcher.c uses both
 * comparators as `qsort()` callbacks. The build does not use LTO, so putting the
 * definitions in a header is what makes this cross-translation-unit inlining
 * possible.
 */

#ifndef COMPARE_H
#define COMPARE_H

#include <stddef.h> /* for size_t */
#include <string.h> /* for strncmp() */

#include "commandt.h" /* for haystack_t */
#include "str.h" /* for str_t */

/**
 * Orders two `haystack_t` (each passed as a `const void *`) alphabetically by
 * candidate contents, with the shorter string winning ties.
 */
static inline int commandt_cmp_alpha(const void *a, const void *b) {
    str_t *a_str = ((haystack_t *)a)->candidate;
    str_t *b_str = ((haystack_t *)b)->candidate;
    const char *a_ptr = a_str->contents;
    const char *b_ptr = b_str->contents;
    size_t a_len = a_str->length;
    size_t b_len = b_str->length;
    int order = strncmp(a_ptr, b_ptr, b_len);
    if (order == 0) {
        return (long)a_len - (long)b_len; // Shorter string wins.
    } else {
        return order;
    }
}

/**
 * Orders two `haystack_t` (each passed as a `const void *`) by score,
 * descending, breaking ties alphabetically.
 *
 * Called directly by `heap.c` (the heap's hard-coded comparator) and, via
 * `cmp_score_p()`, by the final `qsort()` in matcher.c.
 */
static inline int commandt_cmp_score(const void *a, const void *b) {
    float a_score = ((haystack_t *)a)->score;
    float b_score = ((haystack_t *)b)->score;
    if (a_score > b_score) {
        return -1; // `a` should appear before `b`.
    } else if (a_score < b_score) {
        return 1; // `b` should appear before `a`.
    } else {
        return commandt_cmp_alpha(a, b);
    }
}

#endif
