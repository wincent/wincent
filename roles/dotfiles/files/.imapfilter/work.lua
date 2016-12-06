dofile(os.getenv('HOME') .. '/.imapfilter/util.lua')

local me = 'glh@fb.com'
local password = get_pass(me, 'outlook.office365.com')
local phabricator_user = '<PHID-USER-dfiqtsjr7q4b4fu336uy>'
local phabricator_team = '<PHID-PROJ-vgzmhfup375n4lfv4xka>'

function connect()
  return IMAP {
    server = 'outlook.office365.com',
    port = 993,
    username = me,
    password = password,
    ssl = 'auto',
  }
end

function print_status(messages, description)
  label = #messages == 1 and 'message' or 'messages'
  print(description .. ': applied to ' .. #messages .. ' ' .. label)
end

function run()
  print "work: run"

  work = connect()

  -- NOTE: Beware the use of contain_field when talking to an MS server; it is
  -- totally unreliable, so must use the slower match_field method. See:
  --
  -- - https://github.com/lefcha/imapfilter/issues/14
  -- - https://github.com/lefcha/imapfilter/issues/33
  phabricator = work.INBOX:match_field('X-Phabricator-Sent-This-Message', '.')
  differential = phabricator:contain_subject('[Differential]')
  reviewer = differential:match_field('X-Differential-Reviewer', phabricator_user)
  commented = differential:match_field('X-Phabricator-Mail-Tags', '<differential-comment>')
  uncommented = differential - commented
  mine = differential:match_field('X-Differential-Author', phabricator_user)

  messages = phabricator:contain_from(me)
  print_status(messages, 'My [Phabricator] actions -> archive & mark read')
  messages:mark_seen()
  messages:move_messages(work.Archive)

  closed = differential:contain_subject('[Closed]')
  messages = closed:match_field('X-Phabricator-Mail-Tags', '<differential-committed>')
  print_status(messages, '[Closed] -> archive')
  messages:move_messages(work.Archive)

  accepted_and_shipped = differential:contain_subject('[Accepted and Shipped]')
  messages = accepted_and_shipped * uncommented
  print_status(messages, '[Accepted and Shipped] without comments -> archive')
  messages:move_messages(work.Archive)

  accepted = differential:contain_subject('[Accepted]')
  interim = accepted * uncommented
  messages = (accepted * uncommented) - mine
  print_status(messages, "[Accepted] without comments (others' diffs) -> archive")
  messages:move_messages(work.Archive)

  -- Metadata changes (not "[Updated, N line(s)]") without comments.
  updated = differential:contain_subject('[Updated]')
  messages = updated - commented
  print_status(messages, '[Updated] without comments -> archive')
  messages:move_messages(work.Archive)

  planned = differential:contain_subject('[Planned Changes To]')
  messages = planned - commented
  print_status(messages, '[Planned Changes To] without comments -> archive')
  messages:move_messages(work.Archive)

  -- If I'm not direct reviewer, I can probably ignore these.
  messages = planned - reviewer
  print_status(messages, '[Planned Changes To] not direct reviewer -> archive')
  messages:move_messages(work.Archive)

  -- 'Ch1rpBot' matches from, but 'Ch1rpBot <noreply@fb.com>' does not.
  chirp_bot = work.INBOX:contain_from('Ch1rpBot')
  messages = chirp_bot:contain_subject('[land] [success]')
  print_status(messages, '[land] [success] -> archive')
  messages:move_messages(work.Archive)

  requests = differential:
    match_field('X-Phabricator-Mail-Tags', '<differential-review-request')
  self = requests:match_field('X-Differential-Reviewer', phabricator_user)
  team = requests:match_field('X-Differential-Reviewer', phabricator_team)
  messages = requests * (self + team)
  print_status(messages, '[Request] (direct) -> Important')
  messages:mark_flagged()

  -- Archive abandoned and related emails as well.
  abandoned = differential:contain_subject('[Abandoned]'):
    match_field('X-Differential-Status', 'Abandoned')
  for _, message in ipairs(abandoned) do
    mbox, uid = table.unpack(message)
    rev_key = string.gsub(mbox[uid]:fetch_field('In-Reply-To'), 'In%-Reply%-To: ', '')
    related = differential:match_field('In-Reply-To', rev_key) + differential:match_field('Message-ID', rev_key)
    abandoned = abandoned + related
  end
  print_status(abandoned, '[Abandoned] + related -> archive')
  abandoned:move_messages(work.Archive)
end

if os.getenv('DEBUG') then
  print 'DEBUG is set: running once.'
  run()
else
  print 'Looping, to run once set DEBUG.'
  forever(run, 60)
end
