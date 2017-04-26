--[[

"Keylogger" is a module for recording *aggregate* statistics about
keyboard usage into a database for later analysis.

--]]

local log = require 'log'
local retain = require 'retain'
local util = require 'util'

local eventtap = hs.eventtap
local sqlite = hs.sqlite3
local timer = hs.timer
local keyCodes = hs.keycodes.map
local event = eventtap.event
local keyDown = event.types.keyDown
local keyboardEventAutorepeat = event.properties.keyboardEventAutorepeat

local db = nil
local events = {}
local unigrams = {}
local digrams = {}
local trigrams = {}

-- Dump keyDown events into the "events" array.
-- Continually compact events into the "unigrams", "digrams" and "trigrams"
-- arrays.
local keyHandler = (function(evt)
  local when = timer.secondsSinceEpoch()
  local keyCode = evt:getKeyCode()
  local humanReadable = keyCodes[keyCode]
  if not humanReadable or #humanReadable ~= 1 then
    return
  end
  if evt:getProperty(keyboardEventAutorepeat) == 1 then
    return
  end
  local last = {humanReadable = humanReadable, when = when}
  table.insert(events, last)

  -- Compact
  local lastIndex = #events
  local penultimate = events[lastIndex - 1]
  local antepenultimate = events[lastIndex - 2]

  -- Always record the most recent key-press as a unigram.
  table.insert(unigrams, last)

  -- Penultimate becomes part of a digram if it is recent enough.
  if penultimate then
    if penultimate.when > last.when - 1 then
      table.insert(digrams, {
        humanReadable = penultimate.humanReadable .. last.humanReadable,
        when = last.when,
      })
    else
      table.remove(events, lastIndex - 1)
    end
  end

  -- Antepenultimate becomes part of a trigram if it is recent enough.
  if antepenultimate then
    if antepenultimate.when > last.when - 2 then
      table.insert(trigrams, {
        humanReadable = antepenultimate.humanReadable .. penultimate.humanReadable .. last.humanReadable,
        when = last.when,
      })
    end
    table.remove(events, lastIndex - 2)
  end
end)

return {
  init = (function()
    local base = os.getenv('HOME') .. '/.hammerspoon/'
    db = sqlite.open(base .. '/keylogger.sqlite3')
    db:exec([[
      CREATE TABLE IF NOT EXISTS unigrams (ngram VARCHAR(1), count INTEGER, timestamp INTEGER);
      CREATE TABLE IF NOT EXISTS digrams (ngram VARCHAR(2), count INTEGER, timestamp INTEGER);
      CREATE TABLE IF NOT EXISTS trigrams (ngram VARCHAR(3), count INTEGER, timestamp INTEGER);

      CREATE UNIQUE INDEX IF NOT EXISTS unigrams_ngram_timestamp ON unigrams (ngram, timestamp);
      CREATE UNIQUE INDEX IF NOT EXISTS digrams_ngram_timestamp ON digrams (ngram, timestamp);
      CREATE UNIQUE INDEX IF NOT EXISTS trigrams_ngram_timestamp ON trigrams (ngram, timestamp);
    ]])

    retain(eventtap.new({keyDown}, keyHandler):start())

    -- Write to db every hour. We use very coarse buckets to avoid logging too
    -- much literal (non-aggregate) data.
    local interval = 60 * 60 -- every hour
    retain(timer.doEvery(interval, (function ()
      for label, grams in pairs({unigrams = unigrams, digrams = digrams, trigrams = trigrams}) do
        local counts = {}
        for _, gram in pairs(grams) do
          local floor = math.floor(gram.when)
          local timestamp = floor - floor % interval
          local key = gram.humanReadable .. ':' .. timestamp
          if counts[key] == nil then
            counts[key] = 0
          end
          counts[key] = counts[key] + 1
        end
        local statement = db:prepare(
            'INSERT OR REPLACE INTO ' .. label ..
            '  (ngram, count, timestamp) ' ..
            'VALUES (' ..
            '  :ngram, ' ..
            '  COALESCE((SELECT :count + count ' ..
            '            FROM ' .. label .. ' ' ..
            '            WHERE ngram = :ngram ' ..
            '            AND timestamp = :timestamp), :count), ' ..
            '  :timestamp)'
          )
        for key, count in pairs(counts) do
          local ngram = string.match(key, '^.+:'):sub(1, -2)
          local timestamp = string.match(key, '%d+$')
          local status = statement:bind_names({
            ngram = ngram,
            count = count,
            timestamp = timestamp,
          })
          if status ~= sqlite.OK then
            log.d('bind_names() failed with status ' .. status)
          end
          local result = statement:step()
          if result ~= sqlite.DONE then
            log.d('step() failed with result ' .. result)
          end
          statement:reset()
        end
      end

      unigrams = {}
      digrams = {}
      trigrams = {}
    end)))


  end),

  -- For potential debugging purposes.
  db = (function()
    return db
  end),
}
