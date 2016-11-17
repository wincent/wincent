--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local log = require 'log'

local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

local controlKeyCode = 59 -- For some reason this one not in hs.keycodes.map.
local controlDown = {ctrl = true}
local controlUp = {}
local controlPressed = nil
local repeatDelay = hs.eventtap.keyRepeatDelay()
local repeatInterval = hs.eventtap.keyRepeatInterval()
local controlTimer = nil
local controlRepeatTimer = nil

local function modifierHandler(evt)
  local flags=evt:getFlags()
  local keyCode = evt:getKeyCode()

  -- Going to fire a fake f7 key-press so that we can handle this in the
  -- keyHandler function along with Return.
  if keyCode == controlKeyCode then
    -- We only start timers when Control is pressed alone, but we clean them up
    -- unconditionally when it is released, so as not to leak.
    if flags['ctrl'] == nil and controlPressed == true then
      controlPressed = false
      hs.eventtap.event.newKeyEvent({}, 'f7', false):post()
      if controlTimer ~= nil then
        controlTimer:stop()
      end
      if controlRepeatTimer ~= nil then
        controlRepeatTimer:stop()
      end
    elseif deepEquals(flags, controlDown) then
      controlPressed = true
      hs.eventtap.event.newKeyEvent({}, 'f7', true):post()

      -- We don't get repeat events for modifiers. Have to fake them.
      controlTimer = hs.timer.doAfter(
        repeatDelay,
        (function()
          if controlPressed then
            controlRepeatTimer = hs.timer.doUntil(
              (function() return controlPressed == false end),
              (function()
                hs.eventtap.event.newKeyEvent({}, 'f7', true):post()
              end),
              repeatInterval
            )
          end
        end)
      )
    end
  end
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
