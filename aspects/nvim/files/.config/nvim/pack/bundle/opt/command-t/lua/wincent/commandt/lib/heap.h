/**
 * SPDX-FileCopyrightText: Copyright 2016-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

/**
 * @file
 *
 * A fixed size min-heap, originally generic, but now specialized for maximium
 * performance in Command-T in three ways:
 *
 * 1. It's specifically hard-coded to store pointers to `haystack_t` entries.
 * 2. Comparisons are done using hard-coded (and inlined)
 *    `commandt_cmp_score()`, avoiding indirection via a function pointer.
 * 3. When the heap is full, we rely on the caller to do a comparison and
 *    replace the worst entry (the root) in place with a cheap
 *    `heap_replace_top()` shortcut.
 */

#ifndef HEAP_H
#define HEAP_H

#include "commandt.h" /* for haystack_t */

// Define short names for convenience, but all external symbols need prefixes.
#define heap_free commandt_heap_free
#define heap_insert commandt_heap_insert
#define heap_new commandt_heap_new
#define heap_replace_top commandt_heap_replace_top

typedef struct {
    unsigned count;
    unsigned capacity;
    haystack_t **entries;
} heap_t;

#define HEAP_PEEK(heap) (heap->entries[0])

/**
 * Frees a previously created heap.
 */
void heap_free(heap_t *heap);

/**
 * Inserts `value` into `heap`.
 */
void heap_insert(heap_t *heap, haystack_t *value);

/**
 * Returns a new heap.
 */
heap_t *heap_new(unsigned capacity);

/**
 * Replaces the root (worst entry) of `heap` with `value` and restores the heap
 * property.
 *
 * **NOTE:** The caller must have determined that `value` sorts before the
 * current root, allowing us to avoid an expensive insert-then-extract.
 */
void heap_replace_top(heap_t *heap, haystack_t *value);

#endif
