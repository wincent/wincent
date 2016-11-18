--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local log = require 'log'
local util = require 'util'

-- Forward function declarations.
local cancelTimers = nil
local modifierHandler = nil
local keyHandler = nil

local eventtap = hs.eventtap
local event = eventtap.event
local types = event.types
local keyDown = types.keyDown
local keyUp = types.keyUp
local properties = event.properties
local eventSourceUserData = properties.eventSourceUserData
local keyboardEventKeyboardType = properties.keyboardEventKeyboardType
local keyboardEventAutorepeat = properties.keyboardEventAutorepeat
local timer = hs.timer
local t = util.t

local chordThreshold = .5
local syntheticEvent = 94025 -- magic number chosen "at random"
local internalKeyboardType = 43
local externalKeyboardType = 40 -- YubiKey as well...
local stopPropagation = true

local keyCodes = {
  leftControl = 59,
  rightControl = 62,
  leftShift = 56,
  rightShift = 60,
}
local controlDown = {ctrl = true}
local controlUp = {}
local controlPressed = nil
local shiftDown = {shift = true}
local repeatDelay = eventtap.keyRepeatDelay()
local repeatInterval = eventtap.keyRepeatInterval()
local controlTimer = nil
local controlRepeatTimer = nil
local logWarningThreshold = 15

cancelTimers = (function()
  if controlTimer ~= nil then
    controlTimer:stop()
    controlTimer = nil
  end
  if controlRepeatTimer ~= nil then
    controlRepeatTimer:stop()
    controlRepeatTimer = nil
  end
end)

modifierHandler = (function(evt)
  local flags = evt:getFlags()
  local keyCode = evt:getKeyCode()

  -- Going to fire a fake delete key-press so that we can handle this in the
  -- keyHandler function along with return.
  if keyCode == keyCodes.leftControl or keyCode == keyCodes.rightControl then
    -- We only start timers when Control is pressed alone, but we clean them up
    -- unconditionally when it is released, so as not to leak.
    if flags.ctrl == nil and controlPressed == true then
      controlPressed = false
      event.newKeyEvent({}, 'delete', false):post()
      cancelTimers()
    elseif deepEquals(flags, controlDown) then
      controlPressed = true
      event.newKeyEvent({}, 'delete', true):post()

      -- We don't get repeat events for modifiers. Have to fake them.
      cancelTimers()
      controlTimer = timer.doAfter(
        repeatDelay,
        (function()
          if controlPressed then
            controlRepeatTimer = timer.doUntil(
              (function() return controlPressed == false end),
              (function()
                event.newKeyEvent({}, 'delete', true):
                  setProperty(keyboardEventAutorepeat, 1):
                  post()
              end),
              repeatInterval
            )
          end
        end)
      )
    end
  elseif keyCode == keyCodes.leftShift or keyCode == keyCodes.rightShift then
    if deepEquals(flags, shiftDown) then
      if false then
        -- TODO: something like the following, which seems unlikely to work
        -- given what the internets say (requires custom keyboard driver).
        event.newSystemKeyEvent('CAPS_LOCK', true):post()
        timer.doAfter(
          .5,
          (function()
            event.newSystemKeyEvent('CAPS_LOCK', false):post()
          end)
        )
      end
    else
      -- TODO: other modifiers pressed, reset state.
    end
  end
end)

-- These are keys that do one thing when tapped but act like modifiers when
-- chorded.
local conditionalKeys = {}
conditionalKeys.delete = {
  tapped = 'delete',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
  isRepeating = false,
  -- Caps Lock is mapped to control, so during chording, keyDown events should
  -- have these flags.
  expectedFlags = {ctrl = true},
}
conditionalKeys['return'] = {
  tapped = 'return',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
  isRepeating = false,
  expectedFlags = {},
}

keyHandler = (function(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == syntheticEvent then
    return
  end
  local eventType = evt:getType()
  local keyboardType = evt:getProperty(keyboardEventKeyboardType)
  local keyCode = evt:getKeyCode()
  local isRepeatEvent = (evt:getProperty(keyboardEventAutorepeat) ~= 0)
  local flags = evt:getFlags()
  local when = timer.secondsSinceEpoch()
  if eventType == keyDown then
    if keyCode == hs.keycodes.map.i then
      if deepEquals(flags, {ctrl = true}) then
        local frontmost = hs.application.frontmostApplication():bundleID()
        if frontmost == 'com.googlecode.iterm2' or frontmost == 'org.vim.MacVim' then
          event.newKeyEvent({}, 'f6', true):
            setProperty(eventSourceUserData, syntheticEvent):
            post()
          return stopPropagation
        end
      end
    end

    -- Check for conditional keys.
    -- Along the way, note which conditional key(s) are already down.
    local activeConditionals = {}
    for keyName, config in pairs(conditionalKeys) do
      if keyCode == hs.keycodes.map[keyName] then
        -- Sanity checks.
        if config.downAt then
          if when - config.downAt > logWarningThreshold then
            log.w(
              'Suspicious keyDown event received for ' .. keyName .. ' at ' ..
              when .. ' (original downAt was ' .. config.downAt .. ')'
            )
          end
        else
          if isRepeatEvent then
            config.downAt = when - repeatDelay
            log.w(
              'No downAt recorded for repeating keyDown event for ' ..
              keyName .. ' (using best guess ' .. config.downAt .. ')'
            )
          end
        end

        if not deepEquals(flags, {}) or
          (config.downAt and when - config.downAt > chordThreshold) then
          if not config.isChording then
            return
          end
        elseif not config.downAt then
          config.downAt = when
        end
        return stopPropagation
      elseif config.downAt then
        activeConditionals[keyName] = config
      end
    end

    -- Potentially begin chording against the active conditionals.
    for keyName, config in pairs(activeConditionals) do
      if config.isChording or when - config.downAt < chordThreshold then
        if deepEquals(flags, config.expectedFlags) then
          config.isChording = true
          local syntheticFlags = {}
          syntheticFlags[config.chorded] = true
          evt:
            copy():
            setFlags(syntheticFlags):
            setProperty(eventSourceUserData, syntheticEvent):
            post()
          return stopPropagation
        end
      end
    end
  elseif eventType == keyUp then
    for keyName, config in pairs(conditionalKeys) do
      if keyCode == hs.keycodes.map[keyName] then
        local downAt = config.downAt
        config.downAt = nil
        if config.isChording then
          config.isChording = false
        elseif deepEquals(flags, {}) and
          downAt and
          when - downAt <= chordThreshold then
          event.newKeyEvent({}, config.tapped, true):
            setProperty(eventSourceUserData, syntheticEvent):
            post()
        else
          return
        end
        return stopPropagation
      end
    end
  end
end)

return {
  init = (function()
    eventtap.new({types.flagsChanged}, modifierHandler):start()
    eventtap.new({keyDown, keyUp}, keyHandler):start()
  end),
  __debug = {
    conditionalKeys = conditionalKeys,
  },
}
