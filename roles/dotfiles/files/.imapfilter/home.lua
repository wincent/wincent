dofile(os.getenv('HOME') .. '/.imapfilter/util.lua')

local password = get_pass('greg+mutt@hurrell.net', 'imap.gmail.com')
local me = 'greg@hurrell.net'

function connect()
  return IMAP {
    server = 'imap.gmail.com',
    username = me,
    password = password,
    ssl = 'auto',
  }
end

function run()
  home = connect()
  inbox = home.INBOX

  --
  -- Mailing lists
  --

  messages =
    inbox:contain_from('info@reprorights.org') +
    inbox:contain_from('members@nrdcaction.org')
  print_status(messages, '* -> Lists')
  messages:move_messages(home.Lists)

  messages = (
    inbox:contain_from('Lambda-Legal@lambdalegal.org') +
    inbox:contain_from('givewell.org') +
    inbox:contain_from('no-reply@thetrevorproject.org')
  ):match_field('X-campaignid', '.')
  print_status(messages, 'Campaigns -> Lists')
  messages:move_messages(home.Lists)

  --
  -- Notifications
  --

  messages = inbox:
    contain_cc('your_activity@noreply.github.com'):
    contain_cc(me)
  print_status(messages, 'GitHub own activity -> archive & mark read')
  messages:mark_seen()
  messages:delete_messages() -- Archive

  --
  -- Recruiting
  --

  messages = inbox:contain_from('mirrorplacement.com')
  print_status(messages, '* -> Recruiting')
  messages:move_messages(home.Recruiting)
end

if os.getenv('DEBUG') then
  print 'DEBUG is set: running once.'
  run()
else
  print 'Looping, to run once set DEBUG.'
  forever(run, 60)
end
