-- Use 12x12 grid, which allows us to place on quarters, thirds and halves etc.
local width = 12
local height = 12

hs.grid.setGrid(width .. 'x' .. height)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.window.animationDuration = 0 -- disable animations

local events = require('events')
local iterm = require('iterm')
local log = require('log')
local reloader = require('reloader')

-- Forward function declarations.
local activate = nil
local activateLayout = nil
local canManageWindow = nil
local chain = nil
local handleScreenEvent = nil
local handleWindowEvent = nil
local hide = nil
local initEventHandling = nil
local internalDisplay = nil
local tearDownEventHandling = nil
local windowCount = nil

local screenCount = #hs.screen.allScreens()

-- Returns a string specifing window location and dimensions on the grid of the
-- form:
--
--   "${x},${y} ${width}x${height}".
--
-- Example: "0,0 12x6" (represents a rectangle starting in the top-left,
-- occupying the full width of the screen and half the height.
local rect = function(x, y, w, h)
  return string.format('%d,%d %dx%d', x, y, w, h)
end

local grid = {
  full = {
    width = width,
    height = height,
  },
  half = {
    width = width / 2,
    height = height / 2,
  },
  third = {
    width = width / 3,
    height = height / 3,
  },
  quarter = {
    width = width / 4,
    height = height / 4,
  },
  sixth = {
    width = width / 6,
    height = height / 6,
  },
  twelth = {
    width = width / 12,
    height = height / 12,
  },
  two = {
    thirds = {
      width = 2 * width / 3,
      height = 2 * height / 3,
    },
  },
  three = {
    quarters = {
      width = 3 * width / 4,
      height = 3 * height / 4,
    },
  },
  five = {
    sixths = {
      width = 5 * width / 6,
      height = 5 * height / 6,
    },
  },
}
local placements = {
  centered = {
    full = rect(0, 0, grid.full.width, grid.full.height),
    huge = rect(grid.twelth.width, grid.twelth.height, grid.five.sixths.width, grid.five.sixths.height),
    big = rect(grid.sixth.width, grid.sixth.height, grid.two.thirds.width, grid.two.thirds.height),
    medium = rect(grid.quarter.width, grid.quarter.height, grid.half.width, grid.half.height),
    small = rect(grid.third.width, grid.third.height, grid.third.width, grid.third.height),
  },
  top = {
    half = rect(0, 0, grid.full.width, grid.half.height),
    third = rect(0, 0, grid.full.width, grid.third.height),
    quarter = rect(0, 0, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, 0, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, 0, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, 0, grid.half.width, grid.half.height),
    right = rect(grid.half.width, 0, grid.half.width, grid.half.height),
  },
  right = {
    half = rect(grid.half.width, 0, grid.half.width, grid.full.height),
    third = rect(grid.two.thirds.width, 0, grid.third.width, grid.full.height),
    quarter = rect(grid.three.quarters.width, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(grid.third.width, 0, grid.two.thirds.width, grid.full.height),
    },
    three = {
      quarters = rect(grid.quarter.width, 0, grid.three.quarters.width, grid.full.height),
    },
  },
  bottom = {
    half = rect(0, grid.half.height, grid.full.width, grid.half.height),
    third = rect(0, grid.two.thirds.height, grid.full.width, grid.third.height),
    quarter = rect(0, grid.three.quarters.height, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, grid.third.height, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, grid.quarter.height, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, grid.half.height, grid.half.width, grid.half.height),
    right = rect(grid.half.width, grid.half.height, grid.half.width, grid.half.height),
  },
  left = {
    half = rect(0, 0, grid.half.width, grid.full.height),
    third = rect(0, 0, grid.third.width, grid.full.height),
    quarter = rect(0, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(0, 0, grid.two.thirds.width, grid.full.height),
    },
    three = {
      quarters = rect(0, 0, grid.three.quarters.width, grid.full.height),
    },
  },
}

local layoutConfig = {
  _before_ = function()
    hide('com.spotify.client')
  end,

  _after_ = function()
    -- Make sure iTerm appears in front of others.
    activate('com.googlecode.iterm2')
  end,

  ['com.google.Chrome'] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  ['com.google.Chrome.canary'] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  ['com.googlecode.iterm2'] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  ['com.microsoft.edgemac'] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  ['com.tinyspeck.slackmacgap'] = function(window)
    hs.grid.set(window, placements.centered.full, internalDisplay())
  end,

  ['net.kovidgoyal.kitty'] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,
}

--
-- Utility and helper functions.
--

-- Returns the number of standard, non-minimized windows in the application.
--
-- (For Chrome, which has two windows per visible window on screen, but only one
-- window per minimized window).
windowCount = function(app)
  local count = 0
  if app then
    for _, window in pairs(app:allWindows()) do
      if window:isStandard() and not window:isMinimized() then
        count = count + 1
      end
    end
  end
  return count
end

hide = function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end

activate = function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate()
  end
end

canManageWindow = function(window)
  local application = window:application()
  local bundleID = application:bundleID()

  -- Special handling for iTerm: windows without title bars are
  -- non-standard.
  return window:isStandard() or bundleID == 'com.googlecode.iterm2'
end

local benQPD2700U = '1920x1080'
local macBookPro13 = '1440x900'
local macBookPro15 = '1440x900'

local samsung_S24C450 = '1920x1200'

externalDisplay = function()
  return hs.screen.find(benQPD2700U)
end

internalDisplay = function()
  return hs.screen.find(macBookPro13) or hs.screen.find(macBookPro15)
end

activateLayout = function(forceScreenCount)
  layoutConfig._before_()
  events.emit('layout', forceScreenCount)

  for bundleID, callback in pairs(layoutConfig) do
    local application = hs.application.get(bundleID)
    if application then
      local windows = application:visibleWindows()
      for _, window in pairs(windows) do
        if canManageWindow(window) then
          callback(window, forceScreenCount)
        end
      end
    end
  end

  layoutConfig._after_()
end

--
-- Event-handling
--

handleWindowEvent = function(window)
  if canManageWindow(window) then
    local application = window:application()
    local bundleID = application:bundleID()
    if layoutConfig[bundleID] then
      layoutConfig[bundleID](window)
    end
  end
end

local windowFilter = hs.window.filter.new()
windowFilter:subscribe(hs.window.filter.windowCreated, handleWindowEvent)

handleScreenEvent = function()
  -- Make sure that something noteworthy (display count) actually
  -- changed. We no longer check geometry because we were seeing spurious
  -- events.
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
  end
end

initEventHandling = function()
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end

tearDownEventHandling = function()
  screenWatcher:stop()
  screenWatcher = nil
end

local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
chain = function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if lastSeenChain ~= movements or lastSeenAt < now - chainResetInterval or lastSeenWindow ~= id then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif sequenceNumber == 1 then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

--
-- Key bindings.
--

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'up',
  chain({
    placements.top.half,
    placements.top.third,
    placements.top.quarter,
    placements.top.three.quarters,
    placements.top.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'right',
  chain({
    placements.right.half,
    placements.right.third,
    placements.right.quarter,
    placements.right.three.quarters,
    placements.right.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'down',
  chain({
    placements.bottom.half,
    placements.bottom.third,
    placements.bottom.quarter,
    placements.bottom.three.quarters,
    placements.bottom.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'left',
  chain({
    placements.left.half,
    placements.left.third,
    placements.left.quarter,
    placements.left.three.quarters,
    placements.left.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' },
  'up',
  chain({
    placements.top.left,
    placements.top.right,
    placements.bottom.right,
    placements.bottom.left,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' },
  'down',
  chain({
    placements.centered.full,
    placements.centered.huge,
    placements.centered.big,
    placements.centered.medium,
    placements.centered.small,
  })
)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f1', function()
  hs.alert('One-monitor layout')
  activateLayout(1)
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f2', function()
  hs.alert('Two-monitor layout')
  activateLayout(2)
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f3', function()
  hs.console.alpha(0.75)
  hs.toggleConsole()
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f4', function()
  hs.notify.show('Hammerspoon', 'Reloaded in the background', 'Press ⌃⌥⌘F3 to reveal the console.')
  reloader.reload()
end)

hs.hotkey.bind('alt', 'v', function()
  hs.applescript([[
    tell application "System Events" to tell process "Finder"
      set frontmost to true
      tell menu bar item "Edit" of menu bar 1
        click
        click menu item "Show Clipboard" of menu 1
      end tell
    end tell
  ]])
end)

iterm.init()
reloader.init()
initEventHandling()
events.subscribe('reload', tearDownEventHandling)

log.i('Config loaded')
