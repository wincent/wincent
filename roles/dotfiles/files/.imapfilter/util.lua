-- A bunch of global utility functions.

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
  print(description .. ': applied to ' .. #messages .. ' ' .. label)
end

function sleep(seconds)
  os.execute('sleep ' .. tonumber(seconds))
end

function trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end
