/**
 * SPDX-FileCopyrightText: Copyright 2010-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef SCORE_H
#define SCORE_H

#include <stdbool.h> /* for bool */
#include <stdint.h> /* for uint32_t */

#include "commandt.h" /* for haystack_t, matcher_t */

// Needle masks use only bits 0..25, so bit 31 can track whether a candidate
// mask has been computed without affecting the subset test.
#define UNSET_HAYSTACK_BITMASK UINT32_C(0)
#define UNSET_NEEDLE_BITMASK UINT32_MAX
#define HAYSTACK_BITMASK_COMPUTED (UINT32_C(1) << 31)

static inline bool commandt_haystack_bitmask_computed(uint32_t bitmask) {
    return (bitmask & HAYSTACK_BITMASK_COMPUTED) != 0;
}

// Map a candidate byte into one of 32 lossy buckets. Uppercase and lowercase
// ASCII letters differ by 32 and therefore share a bucket. Non-letters may
// collide with letters, producing harmless false positives in the prefilter.
// Masking the index makes the 32-bit shift defined while compiling to the same
// wrapping scalar shift used by the historical scorer.
static inline uint32_t commandt_haystack_char_bit(unsigned char c) {
    unsigned index = ((unsigned)c - (unsigned)'a') & 31u;
    return UINT32_C(1) << index;
}

// Raw byte for use with memset(), so we can initialize the entire memoization
// matrix in a single highly-optimized call.
#define UNSET_SCORE_BYTE 0x7f

// Repeated bytes (repeating pattern used because it's the same on any endianness).
#define UNSET_SCORE_BITS 0x7f7f7f7f

// Compile-time check. Use byte-replication trick to prove UNSET_SCORE_BITS
// stays in sync with UNSET_SCORE_BYTE.
_Static_assert(
    UNSET_SCORE_BITS == (uint32_t)UNSET_SCORE_BYTE * 0x01010101u,
    "UNSET_SCORE_BITS must be 4 bytes of UNSET_SCORE_BYTE"
);

// Type-punning via union: allows us to interpret 0x7f7f7f7f as a float.
// This is a large positive value (~3.39e38), far beyond the scoring range
// (0.0-1.0), and neither NaN nor infinite (needed when compiling with
// `-ffast-math`).
#define UNSET_SCORE \
    (((union { \
         uint32_t bits; \
         float score; \
     }){.bits = UNSET_SCORE_BITS}) \
         .score)

// Compile-time check. All of this relies on floats actually being 4 bytes,
// seeing as we built our float representation using uint32_t.
_Static_assert(sizeof(float) == 4, "UNSET_SCORE/memset init assumes 4-byte float");

/**
 * Scores `haystack` against `matcher`'s needle. `threshold` is the minimum score
 * the candidate must reach to be useful (the smallest score currently in the
 * results heap); pass 0 to always score in full. When positive, the scorer may
 * return early with a value below `threshold` as soon as it can prove the final
 * score cannot reach it.
 */
float commandt_score(
    haystack_t *haystack, matcher_t *matcher, bool ignore_case, float threshold
);

/**
 * An admissible upper bound on the score that any candidate of length
 * `candidate_length` could achieve for a needle of length `needle_length`. Used
 * by the matcher to skip candidates that cannot possibly enter the results heap.
 */
float commandt_score_upper_bound(size_t needle_length, size_t candidate_length);

#endif
