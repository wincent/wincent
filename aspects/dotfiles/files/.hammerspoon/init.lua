local start = hs.timer.absoluteTime()

-- Use 12x12 grid, which allows us to place on quarters, thirds and halves etc.
local width = 12
local height = 12

hs.grid.setGrid(width .. 'x' .. height)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.window.animationDuration = 0 -- disable animations

local events = require('events')
local log = require('log')
local reloader = require('reloader')

-- Forward function declarations.
local activateLayout = nil
local arrangeDisplays = nil
local canManageWindow = nil
local chain = nil
local getMenu = nil
local handleScreenEvent = nil
local handleWindowEvent = nil
local hide = nil
local initEventHandling = nil
local initMenu = nil
local externalDisplay = nil
local internalDisplay = nil
local menu = nil
local tearDownEventHandling = nil

log.i('Evaluating configuration')

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

local bundle_identifiers = {
  Chrome = 'com.google.Chrome',
  ChromeCanary = 'com.google.Chrome.canary',
  Edge = 'com.microsoft.edgemac',
  Orion = 'com.kagi.kagimacOS',
  Slack = 'com.tinyspeck.slackmacgap',
  Spotify = 'com.spotify.client',
  kitty = 'net.kovidgoyal.kitty',
}

local layoutConfig = {
  _before_ = function()
    hide(bundle_identifiers.Spotify)
  end,

  _after_ = function() end,

  [bundle_identifiers.Chrome] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  [bundle_identifiers.ChromeCanary] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  [bundle_identifiers.Orion] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    local internal = internalDisplay()
    if count == 1 or internal == nil then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, internal)
    end
  end,

  [bundle_identifiers.Edge] = function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, hs.screen.primaryScreen())
    end
  end,

  [bundle_identifiers.Slack] = function(window)
    local internal = internalDisplay()
    if internal == nil then
      hs.grid.set(window, placements.centered.full)
    else
      hs.grid.set(window, placements.centered.full, internalDisplay())
    end
  end,

  [bundle_identifiers.kitty] = function(window, forceScreenCount)
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

hide = function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end

canManageWindow = function(window)
  return window:isStandard()
end

local benQPD2700U = '1920x1080' -- real resolution = '3840x2160'
local dellU2723QE = '1920x1080' -- real resolution = '3840x2160'

-- https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-m3-max-14-core-cpu-30-core-gpu-14-late-2023-specs.html
local macBookPro14_2023 = '1512x982' -- real resolution = '3024x1964'

-- https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i7-2.8-15-dual-graphics-mid-2015-retina-display-specs.html
local macBookPro15_2015 = '1440x900' -- real resolution = '2880x1800'

-- https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-m3-max-16-core-cpu-40-core-gpu-16-late-2023-specs.html
local macBookPro15_2023 = '1728x1117' -- real resolution = '3456x2234'

externalDisplay = function()
  return hs.screen.find(benQPD2700U) or hs.screen.find(dellU2723QE)
end

internalDisplay = function()
  return hs.screen.find(macBookPro14_2023) or hs.screen.find(macBookPro15_2015) or hs.screen.find(macBookPro15_2023)
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
  log.i('Handling screen event')
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
    if menu then
      if screenCount == 2 then
        log.i('Returning menu to menu bar')
        menu:returnToMenuBar()
      else
        log.i('Removing menu to menu bar')
        menu:removeFromMenuBar()
      end
    end
  end
end

initEventHandling = function()
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end

local displaysAreVertical = function()
  local internal = internalDisplay()
  local external = externalDisplay()
  if internal and external then
    if internal:fullFrame().y >= external:fullFrame().h then
      return true
    end
  end
  return false
end

arrangeDisplays = function(arrangement)
  local external = externalDisplay()
  local internal = internalDisplay()
  if internal and external then
    local internalFrame = internal:fullFrame()
    local externalFrame = external:fullFrame()
    if arrangement == 'vertical' then
      -- Center internal display underneath the external one.
      internal:setOrigin((externalFrame.w - internalFrame.w) / 2, externalFrame.h)
    else
      -- Place internal display to the right of the external one, near the bottom.
      internal:setOrigin(externalFrame.w, externalFrame.h - internalFrame.h)
    end
    if menu and getMenu then
      menu:setMenu(getMenu())
    end
  end
end

getMenu = function()
  local vertical = displaysAreVertical()
  return {
    {
      title = 'Vertical',
      fn = function()
        arrangeDisplays('vertical')
      end,
      checked = vertical,
    },
    {
      title = 'Horizontal',
      fn = function()
        arrangeDisplays('horizontal')
      end,
      checked = not vertical,
    },
  }
end

initMenu = function()
  local visible = screenCount > 1
  menu = hs.menubar.new(visible, 'dev.wincent.hammerspoon.menu'):setMenu(getMenu()):setIcon([[ASCII:
................
.A............B.
.E..............
...G........H...
...K.......L....
....O.....P.....
....N......M....
...J........I...
................
.D............C.
................
......R..S......
................
......W..T......
...V........U...
................
]])
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

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'escape', function()
  hs.alert('One-monitor layout (^⌥⌘-F1)')
  activateLayout(1)
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f1', function()
  hs.alert('One-monitor layout (^⌥⌘-F1)')
  activateLayout(1)
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f2', function()
  hs.alert('Two-monitor layout (^⌥⌘-F2)')
  activateLayout(2)
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f3', function()
  hs.alert('Forcing vertical display arrangement (^⌥⌘-F3)')
  arrangeDisplays('vertical')
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f4', function()
  hs.alert('Forcing horizontal display arrangement (^⌥⌘-F4)')
  arrangeDisplays('horizontal')
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f5', function()
  hs.alert('Toggling console (^⌥⌘-F5)')
  hs.toggleConsole()
end)

hs.hotkey.bind({ 'ctrl', 'alt', 'cmd' }, 'f6', function()
  hs.notify.show('Hammerspoon', 'Reloading in the background (⌃⌥⌘-F6)', 'This may take a few seconds...')
  hs.timer.doAfter(1, function()
    reloader.reload()
  end)
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

reloader.init()
initMenu()
initEventHandling()
events.subscribe('reload', tearDownEventHandling)

local elapsed = math.floor((hs.timer.absoluteTime() - start) / 1000000)
log.i(string.format('Configuration intialized (%dms)', elapsed))
hs.notify.show('Hammerspoon', '', string.format('Initialized in %dms', elapsed))
