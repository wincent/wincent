#!/usr/bin/env luajit

-- SPDX-FileCopyrightText: Copyright 2014-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

-- Summarizes a benchmark log, showing one row per distinct `hash` (clean and
-- `-dirty` variants counted separately) so you can pick a value to pass via the
-- BASE environment variable to `bin/benchmarks/matcher.lua` (or scanner.lua).
--
-- For each hash we show its most recent run, mirroring how `benchmark.lua`
-- resolves BASE (it scans the log backwards and uses the last-found match).
--
-- Usage:
--   bin/benchmarks/summary.lua [matcher|scanner]
--
-- Defaults to "matcher" when no argument is given.

local pwd = os.getenv('PWD')
local source_directory = debug.getinfo(1).source:match('@?(.*/)')
local lua_directory = pwd .. '/' .. source_directory .. '../../lua'
local data_directory = pwd .. '/' .. source_directory .. '../../data'

package.path = lua_directory .. '/?.lua;' .. package.path
package.path = lua_directory .. '/?/init.lua;' .. package.path
package.path = data_directory .. '/?.lua;' .. package.path
package.path = data_directory .. '/?/init.lua;' .. package.path

local target = arg[1] or 'matcher'
if target ~= 'matcher' and target ~= 'scanner' then
  io.stderr:write('Error: unknown target "' .. tostring(target) .. '" (expected "matcher" or "scanner")\n')
  os.exit(1)
end

local module = 'wincent.commandt.benchmark.logs.' .. target
local ok, log = pcall(require, module)
if not ok or type(log) ~= 'table' then
  io.stderr:write('Error: could not load benchmark log "' .. module .. '"\n')
  os.exit(1)
end

-- Split a hash into its clean prefix and a dirty flag.
local function split_hash(hash)
  local clean = hash:match('^(.-)%-dirty$')
  if clean then
    return clean, true
  end
  return hash, false
end

-- Abbreviate a (possibly dirty) hash for display, preserving the `-dirty`
-- suffix since that is what you would pass as BASE.
local function abbreviate(hash)
  local clean, dirty = split_hash(hash)
  return clean:sub(1, 12) .. (dirty and '-dirty' or '')
end

-- Look up the commit subject line, committer date, and committer timestamp for
-- a hash. The subject is returned as "$subject ($YYYY-mm-dd)", or
-- '(unavailable)' if the commit has been garbage-collected (or otherwise cannot
-- be found), in which case the timestamp is nil.
local commit_cache = {}
local function get_commit(hash)
  local clean = split_hash(hash)
  local cached = commit_cache[clean]
  if cached ~= nil then
    return cached.subject, cached.timestamp
  end
  local subject = '(unavailable)'
  local timestamp = nil
  local handle = io.popen('command git log -1 --date=format:%Y-%m-%d --format=%ct%n%cd%n%s ' .. clean .. ' 2>/dev/null')
  if handle then
    local ct = handle:read('*line')
    local date = handle:read('*line')
    local line = handle:read('*line')
    handle:close()
    if line and line ~= '' then
      subject = line .. ' (' .. date .. ')'
      timestamp = tonumber(ct)
    end
  end
  commit_cache[clean] = { subject = subject, timestamp = timestamp }
  return subject, timestamp
end

-- Collapse the log to the most recent run per exact hash string. Because the
-- log is appended in chronological order, a later entry for the same hash
-- always supersedes an earlier one, which matches BASE's last-found semantics.
local latest = {}
for i, entry in ipairs(log) do
  if entry.hash then
    latest[entry.hash] = { entry = entry, index = i }
  end
end

local rows = {}
for _, info in pairs(latest) do
  info.subject, info.timestamp = get_commit(info.entry.hash)
  table.insert(rows, info)
end

-- Sort by committer timestamp (newest commit first). Ties are broken as follows:
--   * For the same commit, the `-dirty` run is always treated as later than the
--     clean one (you can only dirty a tree you already checked out), regardless
--     of when each was actually run.
--   * For genuinely distinct commits that happen to share a timestamp, fall back
--     to most recent benchmark run.
-- Commits that can't be found (garbage-collected) have no timestamp, so they
-- fall to the bottom, ordered among themselves by most recent benchmark run.
table.sort(rows, function(a, b)
  if a.timestamp and b.timestamp then
    if a.timestamp ~= b.timestamp then
      return a.timestamp > b.timestamp
    end
    local a_clean, a_dirty = split_hash(a.entry.hash)
    local b_clean, b_dirty = split_hash(b.entry.hash)
    if a_clean == b_clean then
      if a_dirty ~= b_dirty then
        return a_dirty -- dirty sorts above (later than) clean
      end
      return a.index > b.index
    end
    return a.index > b.index
  elseif a.timestamp then
    return true
  elseif b.timestamp then
    return false
  else
    return a.index > b.index
  end
end)

local function metric(entry)
  local total = entry.timings and entry.timings.total
  if total and total['cpu (avg)'] and total['wall (avg)'] then
    return string.format('%.5f (%.5f)', total['cpu (avg)'], total['wall (avg)'])
  end
  return '-'
end

local body = {
  { 'HASH', 'AVG CPU (WALL)', 'SUBJECT', 'RUN DATE' },
}
for _, info in ipairs(rows) do
  local entry = info.entry
  table.insert(body, {
    abbreviate(entry.hash),
    metric(entry),
    info.subject,
    entry.when or '?',
  })
end

-- Compute column widths.
local widths = {}
for _, row in ipairs(body) do
  for i, cell in ipairs(row) do
    widths[i] = math.max(widths[i] or 0, #cell)
  end
end

local function render(row)
  local parts = {}
  for i, cell in ipairs(row) do
    parts[i] = cell .. string.rep(' ', widths[i] - #cell)
  end
  return (table.concat(parts, '  '):gsub('%s+$', ''))
end

print('Benchmark runs for "' .. target .. '" (pass an abbreviated hash as BASE=... to compare against):\n')

if #rows == 0 then
  print('(no runs logged yet)')
  os.exit(0)
end

print(render(body[1]))

local separator = {}
for i, width in ipairs(widths) do
  separator[i] = string.rep('-', width)
end
print(render(separator))

for i = 2, #body do
  print(render(body[i]))
end
