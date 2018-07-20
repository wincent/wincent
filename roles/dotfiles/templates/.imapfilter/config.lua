-- {{ ansible_managed }}

dofile(os.getenv('HOME') .. '/.imapfilter/common.lua')
dofile(os.getenv('HOME') .. '/.imapfilter/private.lua')

local me = '{{ imap_user }}'
local password = get_pass('{{ imap_keychain_account }}', '{{ imap_keychain_name }}')

function connect()
  return IMAP {
    server = '{{ imap_server }}',
    username = me,
    password = password,
    ssl = 'auto',
  }
end

function run()
  imap = connect()
  inbox = imap.INBOX

  github = (function()
    return inbox:contain_from('notifications@github.com')
  end)

  github_related = (function(messages)
    results = Set {}
    for _, message in ipairs(messages) do
      mbox, uid = table.unpack(message)
      m = mbox[uid]
      parent_date = all or parse_internal_date(m:fetch_date())
      pull_id = string.gsub(
        mbox[uid]:fetch_field('In-Reply-To'),
        'In%-Reply%-To: ',
        ''
      )
      all_github = github()
      related = all_github:match_field('In-Reply-To', pull_id) +
        all_github:match_field('Message-ID', pull_id)

      for _, message in ipairs(related) do
        mbox, uid = table.unpack(message)
        m = mbox[uid]
        date = all or parse_internal_date(m:fetch_date())
        if all or date <= parent_date then
          table.insert(results, message)
        end
      end
    end
    return results
  end)

  --
  -- Mailing lists
  --

  messages =
    inbox:contain_from('info@reprorights.org') +
    inbox:contain_from('members@nrdcaction.org')
  print_status(messages, '* -> Lists')
  messages:move_messages(imap.Lists)

  messages = (
    inbox:contain_from('Lambda-Legal@lambdalegal.org') +
    inbox:contain_from('givewell.org') +
    inbox:contain_from('info@ppnorcal.org') +
    inbox:contain_from('no-reply@thetrevorproject.org') +
    inbox:contain_from('pponline@ppfa.org')
  ):match_field('X-campaignid', '.')
  print_status(messages, 'Campaigns -> Lists')
  messages:move_messages(imap.Lists)

  --
  -- Notifications
  --

  messages = inbox:contain_field('X-GitHub-Sender', 'wincent')
  messages = messages + github_related(messages)
  print_status(messages, 'GitHub own activity -> archive & mark read')
  messages:mark_seen()
  messages:delete_messages() -- Archive

  --
  -- Cron
  --
  messages = inbox
    :contain_from('root@masochist.unixhosts.net')
    :contain_subject('cron.daily')
  print_status(messages, 'Cron -> Cron')
  messages:move_messages(imap.Cron)

  --
  -- Logwatch
  --
  messages = inbox:contain_from('logwatch@masochist.unixhosts.net')
  print_status(messages, 'Logwatch -> Logwatch')
  messages:move_messages(imap.Logwatch)

  --
  -- Recruiting
  --

  messages = Set {}
  all = inbox:select_all()
  for i, address in ipairs(RECRUITERS) do
    messages = messages + all:match_from(address)
  end
  print_status(messages, '* -> Recruiting')
  messages:move_messages(imap.Recruiting)
end

if os.getenv('ONCE') then
  print 'ONCE is set: running once.'
  run_and_log_time(run)
else
  print 'Looping, to run once set ONCE.'
  forever(run, 60)
end
