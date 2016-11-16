--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local log = require 'log'

local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

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
local externalKeyboardType = 40 -- YubiKey as well...

-- These are keys that do one thing when tapped but act like modifiers when
-- chorded.
local conditionalKeys = {}
-- "return" is a reserved word, so have to use longhand:
conditionalKeys['return'] = {}

local function keyHandler(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == syntheticEvent then
    return
  end
  local eventType = evt:getType()
  local keyboardType = evt:getProperty(keyboardEventKeyboardType)
  local keyCode = evt:getKeyCode()
  local when = hs.timer.secondsSinceEpoch()
  if eventType == keyDown then
    local flags = evt:getFlags()
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
  elseif eventType == keyUp then
    if keyCode == hs.keycodes.map['return'] then
      if returnChording then
        returnChording = false
        return true
      end

      -- BUG: returnInitialDown may be nil!
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
end

return {
  init = (function()
    local modifierTap = hs.eventtap.new(
      {hs.eventtap.event.types.flagsChanged},
      modifierHandler
    )
    modifierTap:start()
    local keyTap = hs.eventtap.new({keyDown, keyUp}, keyHandler)
    keyTap:start()
  end)
}
