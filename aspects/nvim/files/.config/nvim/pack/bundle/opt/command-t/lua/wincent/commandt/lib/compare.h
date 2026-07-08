/**
 * SPDX-FileCopyrightText: Copyright 2010-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

/**
 * @file
 *
 * Haystack ordering comparators.
 *
 * `static inline` in a header for inlining into hot callers.
 */

#ifndef COMPARE_H
#define COMPARE_H

#include <stddef.h> /* for size_t */
#include <string.h> /* for strncmp() */

#include "commandt.h" /* for haystack_t */
#include "str.h" /* for str_t */

/**
 * Orders two `haystack_t` alphabetically by candidate contents, with the
 * shorter string winning ties.
 */
static inline int commandt_cmp_alpha(const haystack_t *a, const haystack_t *b) {
    str_t *a_str = a->candidate;
    str_t *b_str = b->candidate;
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
 * Orders two `haystack_t` by score, descending, breaking ties alphabetically.
 *
 * Called directly by `heap.c` (the heap's hard-coded comparator) and, via
 * `cmp_score_p()`, by the final `qsort()` in matcher.c.
 */
static inline int commandt_cmp_score(const haystack_t *a, const haystack_t *b) {
    float a_score = a->score;
    float b_score = b->score;
    if (a_score > b_score) {
        return -1; // `a` should appear before `b`.
    } else if (a_score < b_score) {
        return 1; // `b` should appear before `a`.
    } else {
        return commandt_cmp_alpha(a, b);
    }
}

#endif
