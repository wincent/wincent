-- A bunch of global utility functions.

local colors = {
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

-- Alternative to `become_daemon(60, callback, true, true)`.
-- (Can interact with via Control-C; Useful for running in a tmux pane.)
function forever(callback, interval)
  while true do
    callback()
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
  bg = #messages > 0 and colors.green.bg or colors.yellow.bg
  print(
    escape(colors.black.fg, bg) ..
    description .. ': applied to ' .. #messages .. ' ' .. label ..
    escape(colors.reset)
  )
end

function sleep(seconds)
  os.execute('sleep ' .. tonumber(seconds))
end

function trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end
