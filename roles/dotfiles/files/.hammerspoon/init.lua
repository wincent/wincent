hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.window.animationDuration = 0 -- disable animations

local screenCount = #hs.screen.allScreens()
local logLevel = 'debug'
local log = hs.logger.new('wincent', logLevel)

local layoutConfig = {
  ['com.googlecode.iterm2'] = (function(window)
    if screenCount == 1 then
      hs.grid.set(window, '0,0 12x12') -- full screen
    else
      hs.grid.set(window, '0,0 6x12') -- left half
    end
  end),
}

-- Event-handling
--
-- This will become a lot easier once `hs.window.filter`
-- (http://www.hammerspoon.org/docs/hs.window.filter.html) moves out of
-- "experimental" status, but until then, using a manual approach as
-- demonstrated at: https://gist.github.com/tmandry/a5b1ab6d6ea012c1e8c5

local globalWatcher = nil
local watchers = {}
local events = hs.uielement.watcher

function handleGlobalEvent(name, eventType, app)
  if eventType == hs.application.watcher.launched then
    log.df('[event] launched %s', app:bundleID())
    watchApp(app)
  elseif eventType == hs.application.watcher.terminated then
    -- Only the PID is set for terminated apps, so can't log bundleID.
    log.df('[event] terminated PID %d', app:pid())
    unwatchApp(app)
  end
end

function handleAppEvent(element, event)
  if event == events.windowCreated then
    log.df('[event] window %s created', element:id())
    watchWindow(element)
    local bundleID = element:application():bundleID()
    if layoutConfig[bundleID] then
      layoutConfig[bundleID](element)
    end
  else
    log.wf('unexpected app event %d received', event)
  end
end

function handleWindowEvent(window, event, watcher, info)
  if event == events.elementDestroyed then
    log.df('[event] window %s destroyed', info.id)
    watcher:stop()
    watchers[info.pid].windows[info.id] = nil
  else
    log.wf('unexpected window event %d received', event)
  end
end

function watchApp(app)
  local pid = app:pid()
  if watchers[pid] then
    log.wf('attempted watch for already-watch PID %d', pid)
    return
  end

  -- Watch for new windows.
  local watcher = app:newWatcher(handleAppEvent)
  watchers[pid] = {
    watcher = watcher,
    windows = {},
  }
  watcher:start({events.windowCreated})

  -- Watch already-existing windows.
  for i, window in pairs(app:allWindows()) do
    watchWindow(window)
  end
end

function unwatchApp(app)
  local pid = app:pid()
  local appWatcher = watchers[pid]
  if not appWatcher then
    log.wf('attempted unwatch for unknown PID %d', pid)
    return
  end

  appWatcher.watcher:stop()
  for i, watcher in pairs(appWatcher.windows) do
    watcher:stop()
  end
  watchers[pid] = nil
end

function watchWindow(window)
  local pid = window:application():pid()
  local windows = watchers[pid].windows
  if window:isStandard() then
    local id = window:id()
    if not windows[id] then
      local watcher = window:newWatcher(handleWindowEvent, {
        id = id,
        pid = pid,
      })
      windows[id] = watcher
      watcher:start({events.elementDestroyed})
    end
  end
end

function initEventHandling()
  if globalWatcher then
    log.w('attempted global watch, but watcher already initialized')
  end

  -- Watch for application-level events.
  globalWatcher = hs.application.watcher.new(handleGlobalEvent)
  globalWatcher:start()

  -- Watch already-running applications.
  local apps = hs.application.runningApplications()
  for i = 1, #apps do
    if apps[i]:bundleID() ~= 'org.hammerspoon.Hammerspoon' then
      watchApp(apps[i])
    end
  end
end

function tearDownEventHandling()
  globalWatcher:stop()
  globalWatcher = nil
end

initEventHandling()

local lastSeenChain = nil
local lastSeenWindow = nil

-- chain the specified movement commands
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    -- elseif (sequenceNumber == cycleLength) then
    -- TODO: at end of chain, restart chain on next screen
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber])
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

hs.hotkey.bind({'ctrl', 'alt'}, 'up', chain({
  '0,0 12x6', -- top half
  '0,0 12x4', -- top third
  '0,0 12x8', -- top two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'right', chain({
  '6,0 6x12', -- right half
  '8,0 4x12', -- right third
  '4,0 8x12', -- right two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'down', chain({
  '0,6 12x6', -- bottom half
  '0,8 12x4', -- bottom third
  '0,4 12x8', -- bottom two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'left', chain({
  '0,0 6x12', -- left half
  '0,0 4x12', -- left third
  '0,0 8x12', -- left two thirds
}))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'up', chain({
  '0,0 6x6', -- top-left corner
  '6,0 6x6', -- top-right corner
  '6,6 6x6', -- bottom-right corner
  '0,6 6x6', -- bottom-left corner
}))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'down', chain({
  '0,0 12x12', -- full screen
  '3,3 6x6', -- centered, big
  '4,4 4x4', -- centered, small
}))
