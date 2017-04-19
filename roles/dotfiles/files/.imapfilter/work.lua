dofile(os.getenv('HOME') .. '/.imapfilter/common.lua')

local me = 'glh@fb.com'
local password = get_pass('glh+mutt@fb.com', 'outlook.office365.com')
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

function run()
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

    accepted = (function(messages)
      return messages:contain_subject('[Accepted]')
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
    differential = get.differential()
    results = Set {}
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
          table.insert(results, message)
        end
      end
    end
    return results
  end)

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
    accepted = get.accepted(get.differential())
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

  archive("[Commandeered] other people's diff without comment", (function()
    messages = get.differential():contain_subject('[Commandeered]')
    messages = messages - get.authored(messages)
    return messages - get.commented(messages)
  end))

  archive("trunkagent comments on other people's diffs", (function()
    messages = get.differential():contain_from('trunkagent')
    return messages - get.authored(messages)
  end))

  archive("other people's [FBSync] diffs", (function()
    differential = get.differential()

    -- As long as I never work directly *on* FBSync, this shouldn't have any
    -- false positives.
    messages =
      get.requested(differential):contain_body('This revision was automatically created by the [FBSync]') +
      get.accepted(differential):contain_body('Automatically approved by the `fbsync` script') +
      get.commented(differential):contain_body('using `fbsync` script to sync')

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
  -- Notifications
  --

  archive('GitHub own activity -> archive & mark read', (function()
    own = inbox:match_field('X-GitHub-Sender', 'wincent')
    return own + github_related(own)
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
      match_field(
        'X-Facebook-Notify',
        'biz_acct_accept_user_join|' ..
        'biz_finance_perm|' ..
        'biz_obj_access_request|' ..
        'biz_perm_proxy_request|' ..
        'page_fan|' ..
        'page_follow'
      )
  end))
end

if os.getenv('ONCE') then
  print 'ONCE is set: running once.'
  run_and_log_time(run)
else
  print 'Looping, to run once set ONCE.'
  forever(run, 60)
end
