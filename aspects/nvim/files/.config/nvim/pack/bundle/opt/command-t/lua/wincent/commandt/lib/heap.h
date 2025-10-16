/**
 * SPDX-FileCopyrightText: Copyright 2016-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

/**
 * @file
 *
 * A fixed size min-heap implementation.
 */

#ifndef HEAP_H
#define HEAP_H

// Define short names for convenience, but all external symbols need prefixes.
#define heap_extract commandt_heap_extract
#define heap_free commandt_heap_free
#define heap_insert commandt_heap_insert
#define heap_new commandt_heap_new

typedef int (*heap_compare_entries)(const void *a, const void *b);

typedef struct {
    unsigned count;
    unsigned capacity;
    void **entries;
    heap_compare_entries comparator;
} heap_t;

#define HEAP_PEEK(heap) (heap->entries[0])

/**
 * Extracts the minimum value from `heap`.
 */
void *heap_extract(heap_t *heap);

/**
 * Frees a previously created heap.
 */
void heap_free(heap_t *heap);

/**
 * Inserts `value` into `heap`.
 */
void heap_insert(heap_t *heap, void *value);

/**
 * Returns a new heap.
 */
heap_t *heap_new(unsigned capacity, heap_compare_entries comparator);

#endif
