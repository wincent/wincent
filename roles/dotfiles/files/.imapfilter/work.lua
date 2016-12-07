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

  --
  -- Rules
  --

  archive = (function(description, matcher)
    messages = matcher()
    print_status(messages, description .. ' -> archive')
    messages:move_messages(work.Archive)
  end)

  archive_and_mark_read = (function(description, matcher)
    messages = matcher()
    print_status(messages, description .. ' -> archive & mark read')
    messages:mark_seen()
    messages:move_messages(work.Archive)
  end)

  flag = (function(description, matcher)
    messages = matcher()
    print_status(messages, description .. ' -> Important')
    messages:mark_flagged()
  end)

  --
  -- Queries
  --

  get = {
    -- All Differential notifications.
    differential = (function()
      return inbox:
        contain_subject('[Differential]'):
        match_field('X-Phabricator-Sent-This-Message', '.')
    end),

    -- Commented on (by anybody).
    commented = (function(messages)
      return messages:match_field(
        'X-Phabricator-Mail-Tags',
        '<differential-comment>'
      )
    end),

    committed = (function(messages)
      return messages:match_field(
        'X-Phabricator-Mail-Tags',
        '<differential-committed>'
      )
    end),

    requested = (function(messages)
      return messages:match_field(
        'X-Phabricator-Mail-Tags',
        '<differential-review-request>'
      )
    end),

    planned = (function(messages)
      return messages:contain_subject('[Planned Changes To]')
    end),

    -- Authored (by me).
    authored = (function(messages)
      return messages:match_field('X-Differential-Author', phabricator_user)
    end),

    -- Me as a reviewer.
    reviewer = (function(messages)
      return messages:match_field('X-Differential-Reviewer', phabricator_user)
    end),
  }

  --
  -- Utility
  --

  -- Phabricator puts a `In-Reply-To` header containing an `Message-ID` of the
  -- original request.
  --
  -- Pass options `{all = true}` to select all matching messages. By default
  -- (`{all = false}`), only messages older than `messages` are considered.
  differential_related = (function(messages, options)
    all = options and options.all
    related = Set {}
    for _, message in ipairs(messages) do
      mbox, uid = table.unpack(message)
      m = mbox[uid]
      parent_date = all or parse_internal_date(m:fetch_date())
      revision_id = string.gsub(
        mbox[uid]:fetch_field('In-Reply-To'),
        'In%-Reply%-To: ',
        ''
      )
      related = differential:match_field('In-Reply-To', revision_id) +
        differential:match_field('Message-ID', revision_id)
      for _, message in ipairs(related) do
        mbox, uid = table.unpack(message)
        m = mbox[uid]
        date = all or parse_internal_date(m:fetch_date())
        if all or date <= parent_date then
          table.insert(related, message)
        end
      end
    end
    return related
  end)

  --
  -- Differential
  --

  -- Assume that anything I have taken action on, I have seen all previous
  -- actions.
  archive_and_mark_read('My [Differential] actions', (function()
    differential = get.differential():contain_from(me)
    return differential + differential_related(differential)
  end))

  archive('[Closed]', (function()
    messages = get.differential():contain_subject('[Closed]')
    return get.committed(messages)
  end))

  archive('[Accepted and Shipped] without comments', (function()
    accepted_and_shipped = get.differential():
      contain_subject('[Accepted and Shipped]')
    commented = get.commented(accepted_and_shipped)
    return accepted_and_shipped - commented
  end))

  archive("[Accepted] without comments (others' diffs)", (function()
    accepted = get.differential():contain_subject('[Accepted]')
    commented = get.commented(accepted)
    uncommented = accepted - commented
    return uncommented - get.authored(uncommented)
  end))

  -- Metadata changes (not "[Updated, N line(s)]") without comments.
  archive('[Updated] without comments', (function()
    updated = get.differential():contain_subject('[Updated]')
    return updated - get.commented(updated)
  end))

  archive('[Planned Changes To] without comments', (function()
    planned = get.planned(get.differential())
    return planned - get.commented(planned)
  end))

  -- If I'm not direct reviewer, I can probably ignore these.
  archive('[Planned Changes To] not direct reviewer', (function()
    planned = get.planned(get.differential())
    return get.reviewer(planned)
  end))

  archive("trunkagent comments on other people's diffs", (function()
    messages = get.differential():contain_from('trunkagent')
    return messages - get.authored(messages)
  end))

  flag('[Request] (direct)', (function()
    requests = get.requested(get.differential()):is_unflagged()
    self = requests:match_field('X-Differential-Reviewer', phabricator_user)
    team = requests:match_field('X-Differential-Reviewer', phabricator_team)
    return requests * (self + team)
  end))

  -- Archive abandoned and related emails as well.
  archive('[Abandoned] + related', (function()
    abandoned = get.differential():contain_subject('[Abandoned]'):
      match_field('X-Differential-Status', 'Abandoned')
    return abandoned + differential_related(abandoned, {all = true})
  end))

  --
  -- Miscellaneous
  --

  -- 'Ch1rpBot' matches from, but 'Ch1rpBot <noreply@fb.com>' does not.
  archive('[land] [success]', (function()
    return inbox:contain_from('Ch1rpBot'):contain_subject('[land] [success]')
  end))

  --
  -- Business
  --

  archive('Page notifications', (function()
    return inbox:
      contain_from('facebookmail.com'):
      match_field('X-Facebook-Notify', 'page_fan')
  end))
end

if os.getenv('DEBUG') then
  print 'DEBUG is set: running once.'
  run()
else
  print 'Looping, to run once set DEBUG.'
  forever(run, 60)
end
