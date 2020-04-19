-- A bunch of global utility functions.

local MONTHS = {
  Jan = 1,
  Feb = 2,
  Mar = 3,
  Apr = 4,
  May = 5,
  Jun = 6,
  Jul = 7,
  Aug = 8,
  Sep = 9,
  Oct = 10,
  Nov = 11,
  Dec = 12,
}

local COLORS = {
  black = {fg = 30, bg = 40},
  red = {fg = 31, bg = 41},
  green = {fg = 32, bg = 42},
  yellow = {fg = 33, bg = 43},
  blue = {fg = 34, bg = 44},
  magenta = {fg = 35, bg = 45},
  cyan = {fg = 36, bg = 46},
  white = {fg = 37, bg = 47},
  reset = 0,
}

function escape(...)
  local arg = {...}
  local joined = table.concat(arg, ';')
  return '\027[' .. joined .. 'm'
end

function run_and_log_time(callback)
  start = os.time()
  print 'Running callback.'
  callback()
  print('Callback completed in ' .. (os.time() - start) .. 's.')
end

-- Alternative to `become_daemon(60, callback, true, true)`.
-- (Can interact with via Control-C; Useful for running in a tmux pane.)
function forever(callback, interval)
  while true do
    run_and_log_time(callback)
    print(
      'Sleeping for ' ..
      tonumber(interval) ..
      's (CTRL-C once to wake, CTRL-C twice to quit).'
    )
    sleep(interval)
  end
end

function get_pass(account, host)
  -- TODO: shell escape this to guard against programmer error
  local status, output = pipe_from(
    '~/.zsh/bin/get-keychain-pass ' .. account .. ' ' .. host
  )
  -- TODO: freak out if non-zero status.
  return trim(output)
end

function print_status(messages, description)
  label = #messages == 1 and 'message' or 'messages'
  bg = #messages > 0 and COLORS.green.bg or COLORS.yellow.bg
  print(
    escape(COLORS.black.fg, bg) ..
    description .. ': applied to ' .. #messages .. ' ' .. label ..
    escape(COLORS.reset)
  )
end

function sleep(seconds)
  os.execute('sleep ' .. tonumber(seconds))
end

function trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end

-- Parses an IMAP INTERNALDATE string (RFC 3501).
--
-- Expects a string with format "dd-Mon-yyyy hh:mm:ss +hhmm".
--
-- See: http://tools.ietf.org/html/rfc3501#section-2.3.3
function parse_internal_date(date_string)
  -- Based on: http://stackoverflow.com/a/4600967/2103996
  format = '(%d+)-(%a+)-(%d+) (%d+):(%d+):(%d+) ([+-]%d+)'
  day, month, year, hour, min, sec, zone = date_string:match(format)
  month = MONTHS[month]
  local_offset = os.time() - os.time(os.date('!*t'))
  offset = tonumber(zone) - local_offset
  return os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec,
  }) + offset
end
