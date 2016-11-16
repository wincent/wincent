hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

local screenCount = #hs.screen.allScreens()
local logLevel = 'info' -- generally want 'debug' or 'info'
local log = hs.logger.new('wincent', logLevel)

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '3,3 6x6',
  centeredSmall = '4,4 4x4',
}

local layoutConfig = {
  _before_ = (function()
    hide('com.spotify.client')
  end),

  _after_ = (function()
    -- Make sure Textual appears in front of Skype, and iTerm in front of
    -- others.
    activate('com.codeux.irc.textual5')
    activate('com.googlecode.iterm2')
  end),

  ['com.codeux.irc.textual5'] = (function(window)
    hs.grid.set(window, grid.fullScreen, internalDisplay())
  end),

  ['com.flexibits.fantastical2.mac'] = (function(window)
    hs.grid.set(window, grid.fullScreen, internalDisplay())
  end),

  ['com.freron.MailMate'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if isMailMateMailViewer(window) then
      if count == 1 then
        hs.grid.set(window, grid.fullScreen)
      else
        hs.grid.set(window, grid.leftHalf, hs.screen.primaryScreen())
      end
    end
  end),

  ['com.github.atom'] = (function(window)
    -- Leave room for simulator to the right.
    hs.grid.set(window, grid.leftTwoThirds, internalDisplay())
  end),

  ['com.google.Chrome'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      -- First/odd windows go on the RIGHT side of the screen.
      -- Second/even windows go on the LEFT side.
      -- (Note this is the opposite of what we do with Canary.)
      local windows = windowCount(window:application())
      local side = windows % 2 == 0 and grid.leftHalf or grid.rightHalf
      hs.grid.set(window, side, hs.screen.primaryScreen())
    end
  end),

  ['com.google.Chrome.canary'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      -- First/odd windows go on the LEFT side of the screen.
      -- Second/even windows go on the RIGHT side.
      -- (Note this is the opposite of what we do with Chrome.)
      local windows = windowCount(window:application())
      local side = windows % 2 == 0 and grid.rightHalf or grid.leftHalf
      hs.grid.set(window, side, hs.screen.primaryScreen())
    end
  end),

  ['com.googlecode.iterm2'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      hs.grid.set(window, grid.leftHalf, hs.screen.primaryScreen())
    end
  end),

  ['com.skype.skype'] = (function(window)
    hs.grid.set(window, grid.rightHalf, internalDisplay())
  end),
}

--
-- Utility and helper functions.
--

-- Returns the number of standard, non-minimized windows in the application.
--
-- (For Chrome, which has two windows per visible window on screen, but only one
-- window per minimized window).
function windowCount(app)
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

function hide(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end

function activate(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate()
  end
end

function isMailMateMailViewer(window)
  local title = window:title()
  return title == 'No mailbox selected' or
    string.find(title, '%(%d+ messages?%)')
end

function canManageWindow(window)
  local application = window:application()
  local bundleID = application:bundleID()

  -- Special handling for iTerm: windows without title bars are
  -- non-standard.
  return window:isStandard() or
    bundleID == 'com.googlecode.iterm2'
end

function internalDisplay()
  -- Fun fact: this resolution matches both the 13" MacBook Air and the 15"
  -- (Retina) MacBook Pro.
  return hs.screen.find('1440x900')
end

function activateLayout(forceScreenCount)
  layoutConfig._before_()

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

function handleWindowEvent(window)
  if canManageWindow(window) then
    local application = window:application()
    local bundleID = application:bundleID()
    if layoutConfig[bundleID] then
      layoutConfig[bundleID](window)
    end
  end
end

local windowFilter=hs.window.filter.new()
windowFilter:subscribe(hs.window.filter.windowCreated, handleWindowEvent)

function handleScreenEvent()
  -- Make sure that something noteworthy (display count) actually
  -- changed. We no longer check geometry because we were seeing spurious
  -- events.
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
  end
end

function initEventHandling()
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end

function tearDownEventHandling()
  screenWatcher:stop()
  screenWatcher = nil
end

initEventHandling()

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
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
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

hs.hotkey.bind({'ctrl', 'alt'}, 'up', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'right', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'down', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt'}, 'left', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'up', chain({
  grid.topLeft,
  grid.topRight,
  grid.bottomRight,
  grid.bottomLeft,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'down', chain({
  grid.fullScreen,
  grid.centeredBig,
  grid.centeredSmall,
}))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f1', (function()
  hs.alert('One-monitor layout')
  activateLayout(1)
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f2', (function()
  hs.alert('Two-monitor layout')
  activateLayout(2)
end))

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f3', (function()
  hs.alert('Hammerspoon console')
  hs.openConsole()
end))

--
-- Screencast layout
--

function prepareScreencast()
  local screen = 'Color LCD'
  local top = {x=0, y=0, w=1, h=.92}
  local bottom = {x=.4, y=.82, w=.5, h=.1}
  local windowLayout = {
    {'iTerm2', nil, screen, top, nil, nil},
    {'Google Chrome', nil, screen, top, nil, nil},
    {'KeyCastr', nil, screen, bottom, nil, nil},
  }

  hs.application.launchOrFocus('KeyCastr')
  local chrome = hs.appfinder.appFromName('Google Chrome')
  local iterm = hs.appfinder.appFromName('iTerm2')
  for key, app in pairs(hs.application.runningApplications()) do
    if app == chrome or app == iterm or app:name() == 'KeyCastr' then
      app:unhide()
    else
      app:hide()
    end
  end
  hs.layout.apply(windowLayout)
end

-- `open hammerspoon://screencast`
hs.urlevent.bind('screencast', prepareScreencast)

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function deepEquals(a, b)
  local typeA = type(a)
  local typeB = type(b)
  if typeA ~= typeB then
    return false
  end
  if typeA ~= 'table' then
    return a == b
  end
  local meta = getmetatable(a)
  if meta and meta.__eq then
    return a == b
  end
  for k, v in pairs(a) do
    local other = b[k]
    if other == nil or not deepEquals(v, other) then
      return false
    end
  end
  for k, v in pairs(b) do
    local other = a[k]
    if other == nil or not deepEquals(v, other) then
      return false
    end
  end
  return true
end

-- Trying to limp along without Karabiner in Sierra.
function modifierHandler(evt)
  local flags=evt:getFlags()
end

local returnInitialDown = nil
local returnChording = false
local repeatThreshold = .5
local syntheticEvent = 94025 -- magic number chosen "at random"
local eventSourceUserData = hs.eventtap.event.properties['eventSourceUserData']

function keyDownHandler(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == syntheticEvent then
    return
  end
  local flags = evt:getFlags()
  if not deepEquals(flags, {}) then
    return
  end
  local keyCode = evt:getKeyCode()
  local when = hs.timer.secondsSinceEpoch()
  if keyCode == hs.keycodes.map['return'] then
    if not returnInitialDown then
      returnInitialDown = when
      return true -- suppress initial event
    else
      if when - returnInitialDown > repeatThreshold then
        return false -- let the event through
      else
        return true -- suppress until we hit the threshold
      end
    end
  else
    if returnInitialDown then
      if returnChording or when - returnInitialDown < repeatThreshold then
        returnChording = true
        local synthetic = evt:copy()
        synthetic:setFlags({ctrl = true})
        synthetic:setProperty(eventSourceUserData, syntheticEvent)
        synthetic:post()
        return true -- suppress the event
      end
    end
  end
end

-- NOTE: getProperty on event keyboardEventKeyboardType may be useful
function keyUpHandler(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == syntheticEvent then
    return
  end
  local keyCode = evt:getKeyCode()
  if keyCode == hs.keycodes.map['return'] then
    if returnChording then
      returnChording = false
      return true
    end

    local when = hs.timer.secondsSinceEpoch()
    if when - returnInitialDown <= repeatThreshold then
      returnInitialDown = nil
      local synthetic = hs.eventtap.event.newKeyEvent({}, 'return', true)
      synthetic:setProperty(eventSourceUserData, syntheticEvent)
      synthetic:post()
      return false
    else
      returnInitialDown = nil
      return true
    end
  end
end

modifierTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifierHandler)
modifierTap:start()
keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, keyDownHandler)
keyDownTap:start()
keyUpTap = hs.eventtap.new({hs.eventtap.event.types.keyUp}, keyUpHandler)
keyUpTap:start()

--
-- Auto-reload config on change.
--

function reloadConfig(files)
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      tearDownEventHandling()
      hs.reload()
    end
  end
end

local pathwatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
