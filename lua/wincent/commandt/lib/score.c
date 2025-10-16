/**
 * SPDX-FileCopyrightText: Copyright 2010-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include "score.h"

#include <stddef.h> /* for size_t */
#ifdef DEBUG_SCORING
#include <stdio.h> /* for fprintf, stdout, snprintf */
#endif
#include <stdlib.h> /* for NULL */

// Use a struct to make passing params during recursion easier.
typedef struct {
    haystack_t *haystack;
    const char *haystack_p;
    const char *needle_p;
    size_t needle_length;
    size_t *rightmost_match_p; // Rightmost match for each char in needle.
    float max_score_per_char;
    bool always_show_dot_files;
    bool never_show_dot_files;
    bool ignore_case;
    float *memo; // Memoization.
} matchinfo_t;

// TODO: see if can come up with a better name than matchinfo_t

static float recursive_match(
    matchinfo_t *m, // Sharable meta-data.
    size_t haystack_idx, // Where in the path string to start.
    size_t needle_idx, // Where in the needle string to start.
    size_t last_idx, // Location of last matched character.
    float score // Cumulative score so far.
) {
    float *memoized = NULL;
    float seen_score = 0.0f;
    const char *haystack_contents = m->haystack_p;

    // Iterate over needle.
    for (size_t i = needle_idx; i < m->needle_length; i++) {
        char needle_char = m->needle_p[i];

        // Iterate over (valid range of) haystack.
        for (size_t j = haystack_idx; j <= m->rightmost_match_p[i]; j++) {
            char c = needle_char;
            char d = haystack_contents[j];
            char d_lower = d >= 'A' && d <= 'Z' ? d | 0x20 : d;
            if (d == '.') {
                if (j == 0 ||
                    haystack_contents[j - 1] == '/') { // This is a dot-file.
                    int dot_search = c == '.'; // Searching for a dot.
                    if (m->never_show_dot_files ||
                        (!dot_search && !m->always_show_dot_files)) {
                        memoized = &m->memo[j * m->needle_length + i];
                        if (*memoized == UNSET_SCORE) {
                            *memoized = 0.0f;
                        }
                        return 0.0f;
                    }
                }
            }

            char match_char = m->ignore_case ? d_lower : d;
            if (c == match_char) {
                memoized = &m->memo[j * m->needle_length + i];
                if (*memoized != UNSET_SCORE) {
                    return *memoized > seen_score ? *memoized : seen_score;
                }

                // Calculate score.
                float score_for_char = m->max_score_per_char;
                size_t distance = j - last_idx;

                if (distance > 1) {
                    float factor = 1.0f;
                    char last = haystack_contents[j - 1];
                    if (last == '/') {
                        factor = 0.9f;
                    } else if (last == '-' || last == '_' || last == ' ' ||
                               (last >= '0' && last <= '9')) {
                        factor = 0.8f;
                    } else if (last >= 'a' && last <= 'z' && d >= 'A' &&
                               d <= 'Z') {
                        factor = 0.8f;
                    } else if (last == '.') {
                        factor = 0.7f;
                    } else {
                        // If no "special" chars behind char, factor diminishes
                        // as distance from last matched char increases.
                        factor = (1.0f / distance) * 0.75f;
                    }
                    score_for_char *= factor;
                }

                if (j < m->rightmost_match_p[i]) {
                    float sub_score =
                        recursive_match(m, j + 1, i, last_idx, score);
                    if (sub_score > seen_score) {
                        seen_score = sub_score;
                    }
                }
                last_idx = j;
                haystack_idx = last_idx + 1;
                score += score_for_char;
                *memoized = seen_score > score ? seen_score : score;
                if (i == m->needle_length - 1) {
                    // Whole string matched.
                    return *memoized;
                }
            }
        }
    }
    return *memoized = score;
}

float commandt_score(haystack_t *haystack, matcher_t *matcher, bool ignore_case) {
    matchinfo_t m;
    bool compute_bitmasks = haystack->bitmask == UNSET_BITMASK;
    m.haystack = haystack;
    m.haystack_p = m.haystack->candidate->contents;
    m.needle_p = matcher->needle;
    m.needle_length = matcher->needle_length;
    m.rightmost_match_p = NULL;
    m.max_score_per_char =
        (1.0f / m.haystack->candidate->length + 1.0f / m.needle_length) / 2;
    m.always_show_dot_files = matcher->always_show_dot_files;
    m.never_show_dot_files = matcher->never_show_dot_files;
    m.ignore_case = ignore_case;

    // Special case for zero-length search string.
    if (m.needle_length == 0) {
        // Filter out dot files.
        if (m.never_show_dot_files || !m.always_show_dot_files) {
            for (size_t i = 0; i < m.haystack->candidate->length; i++) {
                char c = m.haystack_p[i];
                if (c == '.' && (i == 0 || m.haystack_p[i - 1] == '/')) {
                    return -1.0f;
                }
            }
        }
    } else {
        if (haystack->bitmask != UNSET_BITMASK) {
            if ((matcher->needle_bitmask & haystack->bitmask) !=
                matcher->needle_bitmask) {
                return 0.0f;
            }
        }

        // Pre-scan string:
        // - Bail if it can't match at all.
        // - Record rightmost match for each character (prune search space).
        // - Record bitmask for haystack to speed up future searches.
        size_t rightmost_match_p[m.needle_length];
        m.rightmost_match_p = rightmost_match_p;
        size_t needle_idx = m.needle_length - 1;
        size_t haystack_len = m.haystack->candidate->length;
        size_t haystack_idx = haystack_len ? haystack_len - 1 : 0;
        long mask = 0;
        bool found_needle = false;
        const char *haystack_contents = m.haystack_p;
        if (haystack_len) {
            while (haystack_idx >= needle_idx) {
                char c = haystack_contents[haystack_idx];
                char lower = c >= 'A' && c <= 'Z' ? c | 0x20 : c;
                if (m.ignore_case) {
                    c = lower;
                }
                if (compute_bitmasks) {
                    mask |= (1 << (lower - 'a'));
                }

                char d = m.needle_p[needle_idx];
                if (c == d) {
                    rightmost_match_p[needle_idx] = haystack_idx;
                    if (needle_idx == 0) {
                        found_needle = true;
                        break;
                    } else {
                        needle_idx--;
                    }
                }

                if (haystack_idx == 0) {
                    break;
                } else {
                    haystack_idx--;
                }
            }
        }
        if (compute_bitmasks) {
            if (haystack_len) {
                // In case we broke out of the loop early, compute rest of mask.
                for (size_t i = 0; i <= haystack_idx; i++) {
                    char c = haystack_contents[i];
                    char lower = c >= 'A' && c <= 'Z' ? c | 0x20 : c;
                    mask |= (1 << (lower - 'a'));
                }
            }
            haystack->bitmask = mask;
        }
        if (!found_needle) {
            return 0.0f;
        }

        // Prepare for memoization.
        size_t haystack_limit = rightmost_match_p[m.needle_length - 1] + 1;
        size_t memo_size = m.needle_length * haystack_limit;
        float memo[memo_size];
        for (size_t i = 0; i < memo_size; i++) {
            memo[i] = UNSET_SCORE;
        }
        m.memo = memo;
        float score = recursive_match(&m, 0, 0, 0, 0.0f);
#ifdef DEBUG_SCORING
        fprintf(stdout, "   ");
        for (size_t i = 0; i < m.needle_length; i++) {
            fprintf(stdout, "    %c   ", m.needle_p[i]);
        }
        fprintf(stdout, "\n");
        for (size_t i = 0; i < memo_size; i++) {
            char formatted[8];
            if (i % m.needle_length == 0) {
                long haystack_idx = i / m.needle_length;
                fprintf(stdout, "%c: ", m.haystack_p[haystack_idx]);
            }
            if (memo[i] == UNSET_SCORE) {
                snprintf(formatted, sizeof(formatted), "    -  ");
            } else {
                snprintf(formatted, sizeof(formatted), " %-.4f", memo[i]);
            }
            fprintf(stdout, "%s", formatted);
            if ((i + 1) % m.needle_length == 0) {
                fprintf(stdout, "\n");
            } else {
                fprintf(stdout, " ");
            }
        }

        fprintf(stdout, "Final score: %f\n\n", score);
#endif
        return score;
    }
    return 1.0f;
}
