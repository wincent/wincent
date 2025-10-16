/**
 * SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: BSD-2-Clause
 */

// TODO: implement max_depth
// TODO: implement scan_dot_directories

#include "find.h"

#include <errno.h> /* for errno */
#include <fts.h> /* for fts_close(), fts_open(), fts_read() */
#include <stdlib.h> /* for free() */
#include <string.h> /* for strcmp(), strerror() */

#include "debug.h" /* for DEBUG_LOG() */
#include "scanner.h" /* for scanner_new() */
#include "xmalloc.h" /* for xcalloc() */
#include "xmap.h" /* for xmap(), xmunmap() */
#include "xstrdup.h" /* for xstrdup() */

// TODO: share these with scanner.c
static long MAX_FILES = MAX_FILES_CONF;
static size_t buffer_size = MMAP_SLAB_SIZE_CONF;
static const char *current_directory = ".";

find_result_t *commandt_find(const char *directory, unsigned max_files) {
    find_result_t *result = xcalloc(1, sizeof(find_result_t));

    result->files_size = sizeof(str_t) * (max_files ? max_files + 1 : MAX_FILES);
    result->files = xmap(result->files_size);

    result->buffer_size = buffer_size;
    result->buffer = xmap(result->buffer_size);

    char *buffer = result->buffer;

    // TODO: make sure there is no trailing slash
    char *copy = xstrdup(directory);

    // Drop leading "./" if we're exploring current directory.
    size_t drop = strcmp(directory, current_directory) == 0 ? 2 : 0;

    char *paths[] = {copy, NULL};
#ifdef FTS_NOSTAT_TYPE
    int flags = FTS_LOGICAL | FTS_NOSTAT_TYPE;
#else
    int flags = FTS_LOGICAL | FTS_NOSTAT;
#endif
    FTS *handle = fts_open(paths, flags, NULL);
    if (handle == NULL) {
        result->error = strerror(errno);
    } else {
        FTSENT *node;
        while ((node = fts_read(handle)) != NULL) {
            if (node->fts_info == FTS_F) {
                size_t path_len =
                    strlen(node->fts_path) + 1 - drop; // Include NUL byte.
                if (buffer + path_len > result->buffer + result->buffer_size) {
                    // Would be decidedly odd to get here.
                    DEBUG_LOG("commandt_find(): slab allocation exhausted\n");
                    break;
                }
                str_t *str = &result->files[result->count++];
                memcpy(buffer, node->fts_path + drop, path_len);
                str_init(str, buffer, path_len - 1); // Don't count NUL byte.
                buffer += path_len;

                if (max_files && result->count >= max_files) {
                    break;
                }
            }
        }
        if (errno != 0) {
            result->error = strerror(errno);
        }
        if (fts_close(handle) == -1 && !result->error) {
            result->error = strerror(errno);
        }
    }

    if (result->error) {
        result->error = xstrdup(result->error);
    }

    free(copy);
    return result;
}

scanner_t *commandt_file_scanner(const char *directory, unsigned max_files) {
    find_result_t *result = commandt_find(directory, max_files);
    // BUG: if there is an error here, we effectively swallow it...
    if (result->error) {
        DEBUG_LOG("%s\n", result->error);
    }
    scanner_t *scanner = scanner_new(
        result->count, result->files, result->files_size, result->buffer, result->buffer_size
    );

    // The scanner has taken ownership of `result->files` and `result->buffer`,
    // but we still have to free the rest.
    free((void *)result->error);
    free(result);

    return scanner;
}
