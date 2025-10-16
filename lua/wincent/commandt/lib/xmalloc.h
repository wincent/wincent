/**
 * SPDX-FileCopyrightText: Copyright 2021-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef XMALLOC_H
#define XMALLOC_H

// Define short names for convenience, but all external symbols need prefixes.
#define xcalloc commandt_xcalloc
#define xmalloc commandt_xmalloc
#define xrealloc commandt_xrealloc

#include <stddef.h> /* for size_t */

/**
 * `calloc()` wrapper that calls `abort()` if allocations fails.
 *
 * Note: A future version of this wrapper might free cached data structures and
 * retry before aborting.
 */
void *xcalloc(size_t count, size_t size);

/**
 * `malloc()` wrapper that calls `abort()` if allocation fails.
 *
 * Note: A future version of this wrapper might free cached data structures and
 * retry before aborting.
 */
void *xmalloc(size_t size);

/**
 * `realloc()` wrapper that calls `abort()` if reallocation fails.
 *
 * Note: A future version of this wrapper might free cached data structures and
 * retry before aborting.
 */
void *xrealloc(void *ptr, size_t size);

#endif
