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
    if humanReadable == 'space' then
      humanReadable = ' '
    else
      return
    end
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
      CREATE TABLE IF NOT EXISTS unigrams (ngram VARCHAR(1), count INTEGER);
      CREATE TABLE IF NOT EXISTS digrams (ngram VARCHAR(2), count INTEGER);
      CREATE TABLE IF NOT EXISTS trigrams (ngram VARCHAR(3), count INTEGER);

      CREATE UNIQUE INDEX IF NOT EXISTS unigrams_ngram ON unigrams (ngram);
      CREATE UNIQUE INDEX IF NOT EXISTS digrams_ngram ON digrams (ngram);
      CREATE UNIQUE INDEX IF NOT EXISTS trigrams_ngram ON trigrams (ngram);
    ]])

    retain(eventtap.new({keyDown}, keyHandler):start())

    -- Write to db every minute.
    local interval = 60 -- Seconds.
    retain(timer.doEvery(interval, (function ()
      local start = timer.secondsSinceEpoch()
      local operationCount = 0
      for label, grams in pairs({unigrams = unigrams, digrams = digrams, trigrams = trigrams}) do
        local counts = {}
        for _, gram in pairs(grams) do
          local key = gram.humanReadable
          if counts[key] == nil then
            counts[key] = 0
          end
          counts[key] = counts[key] + 1
        end
        local statement = db:prepare(
            'INSERT OR REPLACE INTO ' .. label ..
            '  (ngram, count) ' ..
            'VALUES (' ..
            '  :ngram, ' ..
            '  COALESCE((SELECT :count + count ' ..
            '            FROM ' .. label .. ' ' ..
            '            WHERE ngram = :ngram), ' ..
            '            :count))'
          )
        for ngram, count in pairs(counts) do
          local status = statement:bind_names({
            ngram = ngram,
            count = count,
          })
          if status ~= sqlite.OK then
            log.d('bind_names() failed with status ' .. status)
          end
          local result = statement:step()
          if result ~= sqlite.DONE then
            log.d('step() failed with result ' .. result)
          end
          statement:reset()
          operationCount = operationCount + 1
        end
        log.d(string.format(
          'keylogger: completed %d operations in %.4f seconds',
          operationCount,
          timer.secondsSinceEpoch() - start
        ))
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
