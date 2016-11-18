--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local log = require 'log'

-- Forward function declarations.
local cancelTimers = nil
local modifierHandler = nil
local keyHandler = nil

local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

local keyCodes = {
  control = 59, -- TODO that's leftControl; figure out rightControl
  leftShift = 56,
  rightShift = 60,
}
local controlDown = {ctrl = true}
local controlUp = {}
local controlPressed = nil
local shiftDown = {shift = true}
local repeatDelay = hs.eventtap.keyRepeatDelay()
local repeatInterval = hs.eventtap.keyRepeatInterval()
local controlTimer = nil
local controlRepeatTimer = nil

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
  local flags=evt:getFlags()
  local keyCode = evt:getKeyCode()

  -- Going to fire a fake delete key-press so that we can handle this in the
  -- keyHandler function along with return.
  if keyCode == keyCodes.control then
    -- We only start timers when Control is pressed alone, but we clean them up
    -- unconditionally when it is released, so as not to leak.
    if flags['ctrl'] == nil and controlPressed == true then
      controlPressed = false
      hs.eventtap.event.newKeyEvent({}, 'delete', false):post()
      cancelTimers()
    elseif deepEquals(flags, controlDown) then
      controlPressed = true
      hs.eventtap.event.newKeyEvent({}, 'delete', true):post()

      -- We don't get repeat events for modifiers. Have to fake them.
      cancelTimers()
      controlTimer = hs.timer.doAfter(
        repeatDelay,
        (function()
          if controlPressed then
            controlRepeatTimer = hs.timer.doUntil(
              (function() return controlPressed == false end),
              (function()
                hs.eventtap.event.newKeyEvent({}, 'delete', true):post()
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
        hs.eventtap.event.newSystemKeyEvent('CAPS_LOCK', true):post()
        hs.timer.doAfter(
          .5,
          (function()
            hs.eventtap.event.newSystemKeyEvent('CAPS_LOCK', false):post()
          end)
        )
      end
    else
      -- TODO: other modifiers pressed, reset state.
    end
  end
end)

local repeatThreshold = .5
local syntheticEvent = 94025 -- magic number chosen "at random"
local eventSourceUserData = hs.eventtap.event.properties['eventSourceUserData']
local keyboardEventKeyboardType = hs.eventtap.event.properties['keyboardEventKeyboardType']
local internalKeyboardType = 43
local externalKeyboardType = 40 -- YubiKey as well...
local stopPropagation = true

-- These are keys that do one thing when tapped but act like modifiers when
-- chorded.
local conditionalKeys = {
  delete = {
    tapped = 'delete',
    chorded = 'ctrl',
    downAt = nil,
    isChording = false,
    -- Caps Lock is mapped to control, so during chording, keyDown events should
    -- have these flags.
    expectedFlags = {ctrl = true},
  },
}
-- "return" is a reserved word, so have to use longhand:
conditionalKeys['return'] = {
  tapped = 'return',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
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
  local flags = evt:getFlags()
  local when = hs.timer.secondsSinceEpoch()
  if eventType == keyDown then
    if keyCode == hs.keycodes.map['i'] then
      if deepEquals(flags, {ctrl = true}) then
        local frontmost = hs.application.frontmostApplication():bundleID()
        if frontmost == 'com.googlecode.iterm2' or frontmost == 'org.vim.MacVim' then
          hs.eventtap.event.newKeyEvent({}, 'f6', true):setProperty(eventSourceUserData, syntheticEvent):post()
          return stopPropagation
        end
      end
    end

    -- Check for conditional keys.
    -- Along the way, note which conditional key(s) are already down.
    local activeConditionals = {}
    for keyName, config in pairs(conditionalKeys) do
      if keyCode == hs.keycodes.map[keyName] then
        if not deepEquals(flags, {}) or
          (config.downAt and when - config.downAt > repeatThreshold) then
          if not config.isChording then
            local synthetic = hs.eventtap.event.newKeyEvent({}, config.tapped, true)
            synthetic:setProperty(eventSourceUserData, syntheticEvent)
            synthetic:post()
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
      if config.isChording or when - config.downAt < repeatThreshold then
        if deepEquals(flags, config.expectedFlags) then
          config.isChording = true
          local synthetic = evt:copy()
          local syntheticFlags = {}
          syntheticFlags[config.chorded] = true
          synthetic:setFlags(syntheticFlags)
          synthetic:setProperty(eventSourceUserData, syntheticEvent)
          synthetic:post()
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
        else
          if deepEquals(flags, {}) and
            when - downAt <= repeatThreshold then
            local synthetic = hs.eventtap.event.newKeyEvent({}, config.tapped, true)
            synthetic:setProperty(eventSourceUserData, syntheticEvent)
            synthetic:post()
          end
        end
        return stopPropagation
      end
    end
  end
end)

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
