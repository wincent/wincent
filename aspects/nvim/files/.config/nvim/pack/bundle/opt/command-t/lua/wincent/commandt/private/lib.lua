-- SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local ffi = require('ffi')

local fetch = require('wincent.commandt.private.fetch')
local toboolean = require('wincent.commandt.private.toboolean')

local lib = {}

-- Lazy-load dynamic (C) library code on first access.
local c = {}

setmetatable(c, {
  __index = function(table, key)
    ffi.cdef([[
      // Types.

      typedef struct {
          const char *contents;
          size_t length;
          ssize_t capacity;
      } str_t;

      typedef struct {
          str_t *candidate;
          long bitmask;
          float score;
      } haystack_t;

      typedef struct {
          unsigned count;
          str_t *candidates;
          ssize_t candidates_size;
          char *buffer;
          ssize_t buffer_size;
      } scanner_t;

      typedef struct {
          scanner_t *scanner;
          haystack_t *haystacks;
          bool always_show_dot_files;
          bool ignore_case;
          bool ignore_spaces;
          bool never_show_dot_files;
          bool smart_case;
          unsigned limit;
          unsigned threads;
          const char *needle;
          size_t needle_length;
          long needle_bitmask;
          const char *last_needle;
          size_t last_needle_length;
      } matcher_t;

      typedef struct {
          str_t **matches;
          unsigned match_count;
          unsigned candidate_count;
      } result_t;

      typedef struct {
          size_t capacity;
          char *payload;
          char *ptr;
          char *end;
      } watchman_response_t;

      typedef struct {
          unsigned count;
          str_t *files;
          const char *error;
          size_t files_size;
          watchman_response_t *response;
      } watchman_query_t;

      typedef struct {
          const char *watch;
          const char *relative_path;
          const char *error;
      } watchman_watch_project_t;

      typedef struct {
        uint32_t seconds;
        uint32_t microseconds;
      } benchmark_t;

      // Matcher functions.

      matcher_t *commandt_matcher_new(
          scanner_t *scanner,
          bool always_show_dot_files,
          bool ignore_case,
          bool ignore_spaces,
          unsigned limit,
          bool never_show_dot_files,
          bool smart_case,
          uint64_t threads
      );
      void commandt_matcher_free(matcher_t *matcher);
      result_t *commandt_matcher_run(matcher_t *matcher, const char *needle);
      void commandt_result_free(result_t *result);

      // Scanner functions.

      scanner_t *commandt_file_scanner(const char *directory, unsigned max_files);
      scanner_t *commandt_scanner_new_command(const char *command, unsigned drop, unsigned max_files);
      scanner_t *commandt_scanner_new_copy(const char **candidates, unsigned count);
      scanner_t *commandt_scanner_new_str(str_t *candidates, unsigned count);
      void commandt_scanner_free(scanner_t *scanner);
      void commandt_print_scanner(scanner_t *scanner);

      // Watchman functions.

      int commandt_watchman_connect(const char *socket_path);
      int commandt_watchman_disconnect(int socket);
      watchman_query_t *commandt_watchman_query(
          const char *root,
          const char *relative_root,
          int socket
      );
      void commandt_watchman_query_free(watchman_query_t *result);
      watchman_watch_project_t *commandt_watchman_watch_project(
          const char *root,
          int socket
      );
      void commandt_watchman_watch_project_free(
          watchman_watch_project_t *result
      );

      // Benchmarking.

      benchmark_t commandt_epoch();

      // Utilities.

      unsigned commandt_processors();

      // Standard library.
      void free(void *ptr);
    ]])

    local dirname = debug.getinfo(1).source:match('@?(.*/)')
    local extension = (function()
      -- Possible values listed here: http://luajit.org/ext_jit.html#jit_os
      if ffi.os == 'Windows' then
        return '.dll'
      end
      return '.so'
    end)()
    c = ffi.load(dirname .. '../lib/commandt' .. extension)
    return c[key]
  end,
})

lib.epoch = function()
  local result = c.commandt_epoch()

  return result['seconds'], result['microseconds']
end

lib.file_scanner = function(directory, max_files)
  local scanner = c.commandt_file_scanner(directory, max_files or 0)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

-- For the first 8 cores, use 1 thread per core.
-- Beyond the first 8 cores, use 1 additional thread per 4 cores.
local default_thread_count = function()
  local count = lib.processors()
  if count < 8 then
    return count
  else
    return 8 + math.floor((count - 8) / 4)
  end
end

lib.matcher_new = function(scanner, options, context)
  local always_show_dot_files = fetch(options, 'always_show_dot_files', false)
  local ignore_case = fetch(options, 'ignore_case', true)
  local ignore_spaces = fetch(options, 'ignore_spaces', true)
  local height = fetch(options, 'height', 15)
  local limit = math.min(height, context and context.lines or 1000)
  local never_show_dot_files = fetch(options, 'never_show_dot_files', false)
  local smart_case = fetch(options, 'smart_case', true)
  local threads = fetch(options, 'threads', default_thread_count())
  if limit < 1 then
    error('limit must be > 0')
  end
  if type(ignore_case) == 'function' then
    ignore_case = toboolean(ignore_case())
  end
  if type(smart_case) == 'function' then
    smart_case = toboolean(smart_case())
  end
  local matcher = c.commandt_matcher_new(
    scanner,
    always_show_dot_files,
    ignore_case,
    ignore_spaces,
    limit,
    never_show_dot_files,
    smart_case,
    threads
  )
  ffi.gc(matcher, c.commandt_matcher_free)
  return matcher
end

lib.matcher_run = function(matcher, needle)
  return c.commandt_matcher_run(matcher, needle)
end

lib.processors = function()
  return c.commandt_processors()
end

-- TODO: order this file
lib.print_scanner = function(scanner)
  c.commandt_print_scanner(scanner)
end

lib.scanner_new_exec = function(command, drop, max_files)
  -- Note that the C-level function would ideally be named
  -- `commandt_scanner_new_exec()`, for consistency, but I am keeping the old
  -- name because I don't want to break userspace (ie. by forcing users to do a
  -- rebuild) just because I felt like refactoring some internal implementation
  -- details...
  local scanner = c.commandt_scanner_new_command(command, drop or 0, max_files or 0)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

lib.scanner_new_copy = function(candidates)
  local count = #candidates
  local scanner = c.commandt_scanner_new_copy(ffi.new('const char *[' .. count .. ']', candidates), count)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

lib.scanner_new_str = function(candidates, count)
  local scanner = c.commandt_scanner_new_str(candidates, count)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

lib.watchman_connect = function(name)
  -- TODO: validate name is a string/path
  local socket = c.commandt_watchman_connect(name)
  if socket == -1 then
    error('commandt_watchman_connect(): failed')
  end
  return socket
end

lib.watchman_disconnect = function(socket)
  -- TODO: validate socket is a number
  local errno = c.commandt_watchman_disconnect(socket)
  if errno ~= 0 then
    error('commandt_watchman_disconnect(): failed with errno ' .. errno)
  end
end

lib.watchman_query = function(root, relative_root, socket)
  local raw = c.commandt_watchman_query(root, relative_root, socket)
  local result = {
    error = raw['error'] ~= nil and ffi.string(raw['error']) or nil,
    raw = raw, -- So caller can access and pass through cdata to matcher.
  }
  ffi.gc(raw, c.commandt_watchman_query_free)
  return result
end

lib.watchman_watch_project = function(root, socket)
  local result = c.commandt_watchman_watch_project(root, socket)
  local project = {
    error = result['error'] ~= nil and ffi.string(result['error']) or nil,
    relative_path = result['relative_path'] ~= nil and ffi.string(result['relative_path']) or nil,
    watch = result['watch'] ~= nil and ffi.string(result['watch']) or nil,
  }
  c.commandt_watchman_watch_project_free(result)
  return project
end

return lib
