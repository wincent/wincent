dofile(os.getenv('HOME') .. '/.imapfilter/util.lua')

local password = get_pass('greg+mutt@hurrell.net', 'imap.gmail.com')

function connect()
  return IMAP {
    server = 'imap.gmail.com',
    username = 'greg@hurrell.net',
    password = password,
    ssl = 'auto',
  }
end

function run()
  print "home: run"
  home = connect()
  home.INBOX:check_status()
end

if os.getenv('DEBUG') then
  print 'DEBUG is set: running once.'
  run()
else
  print 'Looping, to run once set DEBUG.'
  forever(run, 60)
end
