dofile(os.getenv('HOME') .. '/.imapfilter/util.lua')

local me = 'glh@fb.com'
local password = get_pass(me, 'outlook.office365.com')
local phabricator_user = '<PHID-USER-dfiqtsjr7q4b4fu336uy>'
local phabricator_team = '<PHID-PROJ-vgzmhfup375n4lfv4xka>'

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

function connect()
  return IMAP {
    server = 'outlook.office365.com',
    port = 993,
    username = me,
    password = password,
    ssl = 'auto',
  }
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

function run()
  print "work: run"

  -- NOTE: Beware the use of contain_field when talking to an MS server; it is
  -- totally unreliable, so must use the slower match_field method. See:
  --
  -- - https://github.com/lefcha/imapfilter/issues/14
  -- - https://github.com/lefcha/imapfilter/issues/33
  work = connect()
  inbox = work.INBOX
  archive = work.Archive

  --
  -- Phabricator
  --

  phabricator = inbox:match_field('X-Phabricator-Sent-This-Message', '.')
  differential = phabricator:contain_subject('[Differential]')
  reviewer = differential:match_field('X-Differential-Reviewer', phabricator_user)
  commented = differential:match_field('X-Phabricator-Mail-Tags', '<differential-comment>')
  uncommented = differential - commented
  mine = differential:match_field('X-Differential-Author', phabricator_user)

  -- Assume that anything I have taken action on, I have seen all previous
  -- actions.
  --
  -- Phabricator puts a `Reply-To` header containing an ID which includes the
  -- diff number, and all subsequent notifications reference that ID in their
  -- `In-Reply-To` header.
  messages = phabricator:contain_from(me)
  touched = Set {}
  for _, message in ipairs(messages) do
    mbox, uid = table.unpack(message)
    m = mbox[uid]
    parent_date = parse_internal_date(m:fetch_date())
    revision_id = string.gsub(mbox[uid]:fetch_field('In-Reply-To'), 'In%-Reply%-To: ', '')
    related = differential:match_field('In-Reply-To', revision_id) + differential:match_field('Message-ID', revision_id)
    for _, message in ipairs(related) do
      mbox, uid = table.unpack(message)
      m = mbox[uid]
      date = parse_internal_date(m:fetch_date())
      if date <= parent_date then
        table.insert(touched, message)
      end
    end
  end
  messages = messages + touched
  print_status(messages, 'My [Phabricator] actions -> archive & mark read')
  messages:mark_seen()
  messages:move_messages(archive)

  closed = differential:contain_subject('[Closed]')
  messages = closed:match_field('X-Phabricator-Mail-Tags', '<differential-committed>')
  print_status(messages, '[Closed] -> archive')
  messages:move_messages(archive)

  accepted_and_shipped = differential:contain_subject('[Accepted and Shipped]')
  messages = accepted_and_shipped * uncommented
  print_status(messages, '[Accepted and Shipped] without comments -> archive')
  messages:move_messages(archive)

  accepted = differential:contain_subject('[Accepted]')
  interim = accepted * uncommented
  messages = (accepted * uncommented) - mine
  print_status(messages, "[Accepted] without comments (others' diffs) -> archive")
  messages:move_messages(archive)

  -- Metadata changes (not "[Updated, N line(s)]") without comments.
  updated = differential:contain_subject('[Updated]')
  messages = updated - commented
  print_status(messages, '[Updated] without comments -> archive')
  messages:move_messages(archive)

  planned = differential:contain_subject('[Planned Changes To]')
  messages = planned - commented
  print_status(messages, '[Planned Changes To] without comments -> archive')
  messages:move_messages(archive)

  -- If I'm not direct reviewer, I can probably ignore these.
  messages = planned - reviewer
  print_status(messages, '[Planned Changes To] not direct reviewer -> archive')
  messages:move_messages(archive)

  -- trunkagent's comments on other people's diffs.
  messages = differential:contain_from('trunkagent') - mine
  print_status(messages, "trunkagent comments on other people's diffs -> archive")
  messages:move_messages(archive)

  -- 'Ch1rpBot' matches from, but 'Ch1rpBot <noreply@fb.com>' does not.
  chirp_bot = inbox:contain_from('Ch1rpBot')
  messages = chirp_bot:contain_subject('[land] [success]')
  print_status(messages, '[land] [success] -> archive')
  messages:move_messages(archive)

  requests = differential:
    match_field('X-Phabricator-Mail-Tags', '<differential-review-request'):
    is_unflagged()
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
    revision_id = string.gsub(mbox[uid]:fetch_field('In-Reply-To'), 'In%-Reply%-To: ', '')
    related = differential:match_field('In-Reply-To', revision_id) + differential:match_field('Message-ID', revision_id)
    abandoned = abandoned + related
  end
  print_status(abandoned, '[Abandoned] + related -> archive')
  abandoned:move_messages(archive)

  messages = inbox:contain_from('facebookmail.com'):match_field('X-Facebook-Notify', 'page_fan')
  print_status(messages, 'Page notifications -> archive')
  messages:move_messages(archive)
end

if os.getenv('DEBUG') then
  print 'DEBUG is set: running once.'
  run()
else
  print 'Looping, to run once set DEBUG.'
  forever(run, 60)
end
