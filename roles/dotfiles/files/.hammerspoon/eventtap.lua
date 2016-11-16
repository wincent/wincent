--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'

local function modifierHandler(evt)
  local flags=evt:getFlags()
end

local returnInitialDown = nil
local returnChording = false
local repeatThreshold = .5
local syntheticEvent = 94025 -- magic number chosen "at random"
local eventSourceUserData = hs.eventtap.event.properties['eventSourceUserData']
local keyboardEventKeyboardType = hs.eventtap.event.properties['keyboardEventKeyboardType']
local internalKeyboardType = 43
local externalKeyboardType = 40

local function keyDownHandler(evt)
  local keyboardType = evt:getProperty(keyboardEventKeyboardType)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == syntheticEvent then
    return
  end
  local flags = evt:getFlags()
  local keyCode = evt:getKeyCode()
  if keyCode == hs.keycodes.map['i'] then
    if deepEquals(flags, {ctrl = true}) then
      local frontmost = hs.application.frontmostApplication():bundleID()
      if frontmost == 'com.googlecode.iterm2' or frontmost == 'org.vim.MacVim' then
        hs.eventtap.event.newKeyEvent({}, 'f6', true):setProperty(eventSourceUserData, syntheticEvent):post()
        return true
      end
    end
  end
  if not deepEquals(flags, {}) then
    return
  end
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
local function keyUpHandler(evt)
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

return {
  init = (function()
    local modifierTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, modifierHandler)
    modifierTap:start()
    local keyDownTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, keyDownHandler)
    keyDownTap:start()
    local keyUpTap = hs.eventtap.new({hs.eventtap.event.types.keyUp}, keyUpHandler)
    keyUpTap:start()
  end)
}
