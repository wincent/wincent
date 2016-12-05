-- Operators:
--
--   * = AND
--   + = OR
--   - = NOT

function get_pass(account, host)
  -- TODO: shell escape this to guard against programmer error
  local status, output = pipe_from(
    '~/.zsh/bin/get-keychain-pass ' .. account .. ' ' .. host
  )
  -- TODO: freak out if non-zero status.
  return output
end
function trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end

home = IMAP {
  server = 'imap.gmail.com',
  username = 'greg@hurrell.net',
  password = trim(get_pass('greg+mutt@hurrell.net', 'imap.gmail.com')),
  ssl = 'auto',
}

-- TODO: a lot of stuff...
home.INBOX:check_status()

work = IMAP {
  server = 'outlook.office365.com',
  port = 993,
  username = 'glh@fb.com',
  password = trim(get_pass('glh@fb.com', 'outlook.office365.com')),
  ssl = 'auto',
}

-- TODO: more stuff here
work.INBOX:check_status()
