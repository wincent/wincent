--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local log = require 'log'
local retain = require 'retain'
local queue = require 'queue'
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
local keyCodes = hs.keycodes.map
local timer = hs.timer
local t = util.t

local chordThreshold = .5

local injectedEvent = 94025

local modifierEvent = 94117

local internalKeyboardType = 43
local externalKeyboardType = 40 -- YubiKey as well...
local stopPropagation = true

-- Key codes not present in hs.keycodes.map.
local extraKeyCodes = {
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
  if keyCode == extraKeyCodes.leftControl or keyCode == extraKeyCodes.rightControl then
    -- We only start timers when Control is pressed alone, but we clean them up
    -- unconditionally when it is released, so as not to leak.
    if flags.ctrl == nil and controlPressed == true then
      controlPressed = false
      event.newKeyEvent({}, 'delete', false):
        setProperty(eventSourceUserData, modifierEvent):
        post()
      cancelTimers()
    elseif deepEquals(flags, controlDown) then
      controlPressed = true
      event.newKeyEvent({}, 'delete', true):
        setProperty(eventSourceUserData, modifierEvent):
        post()

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
                  setProperty(eventSourceUserData, modifierEvent):
                  setProperty(keyboardEventAutorepeat, 1):
                  post()
              end),
              repeatInterval
            )
          end
        end)
      )
    end
  elseif keyCode == extraKeyCodes.leftShift or keyCode == extraKeyCodes.rightShift then
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
conditionalKeys[keyCodes.delete] = {
  tapped = 'delete',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
  isRepeating = false,
  -- Caps Lock is mapped to control, so during chording, keyDown events for
  -- other keys should have these flags.
  expectedFlags = {ctrl = true},
  expectedUserData = modifierEvent,
  rolloverThreshold = 0.2,
}
conditionalKeys[keyCodes['return']] = {
  tapped = 'return',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
  isRepeating = false,
  expectedFlags = {},
  expectedUserData = 0,
  rolloverThreshold = chordThreshold,
}
local pendingEvents = queue.create()

keyHandler = (function(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == injectedEvent then
    return
  end
  local eventType = evt:getType()
  local keyboardType = evt:getProperty(keyboardEventKeyboardType)
  local keyCode = evt:getKeyCode()
  local isRepeatEvent = (evt:getProperty(keyboardEventAutorepeat) ~= 0)
  local flags = evt:getFlags()
  local when = timer.secondsSinceEpoch()
  if eventType == keyDown then
    if keyCode == keyCodes.i then
      if deepEquals(flags, {ctrl = true}) then
        local frontmost = hs.application.frontmostApplication():bundleID()
        if frontmost == 'com.googlecode.iterm2' or frontmost == 'org.vim.MacVim' then
          event.newKeyEvent({}, 'f6', true):
            setProperty(eventSourceUserData, injectedEvent):
            post()
          return stopPropagation
        end
      end
    end

    -- Check for conditional keys.
    local config = conditionalKeys[keyCode]
    if config and config.expectedUserData == userData then
      if not config.downAt then
        config.downAt = when
      end

      if not deepEquals(flags, {}) or
        when - config.downAt > chordThreshold then
        if not config.isChording then
          return
        end
      end
      return stopPropagation
    end

    -- Potentially begin chording against the first found active conditional.
    for _, config in pairs(conditionalKeys) do
      if config.downAt then
        local injectedFlags = {}
        injectedFlags[config.chorded] = true
        local probablyChording =
          when - config.downAt < config.rolloverThreshold
        if config.isChording or probablyChording then
          config.isChording = true
          if deepEquals(flags, config.expectedFlags) then
            evt:
              copy():
              setFlags(injectedFlags):
              setProperty(eventSourceUserData, injectedEvent):
              post()
            return stopPropagation
          else
            -- Chording but flags don't match. Let through unaltered.
            -- NOTE: may not be right behavior for Caps Lock (because that will
            -- end up with Control flag regardless).
            return
          end
        elseif when - config.downAt < chordThreshold then
          -- Not chording (yet). Hold this in queue until we know whether this
          -- is a chord or just a fast key press.
          pendingEvents.enqueue(
            evt:
              copy():
              setFlags(injectedFlags):
              setProperty(eventSourceUserData, injectedEvent)
          )
          return stopPropagation
        else
          -- Not chording, but this is happening too late to start chording.
          return
        end

        -- Note the simplifying assumption: guaranteed to `return` if we found
        -- an active conditional; we'll just take that one (ie. first wins;
        -- could also consider latest wins).
      end
    end
  elseif eventType == keyUp then
    local config = conditionalKeys[keyCode]
    if config and config.expectedUserData == userData then
      config.downAt = nil
      if config.isChording then
        config.isChording = false
      elseif #pendingEvents > 0 then
        -- Not chording and we had something pending (user is typing fast):
        -- flush it!
        --
        --   Caps Lock *---------*
        --   X              *------*
        --
        event.newKeyEvent({}, config.tapped, true):
          setProperty(eventSourceUserData, injectedEvent):
          post()
        while true do
          local pending = pendingEvents.dequeue()
          if pending then
            pending:setFlags({}):post()
          else
            break
          end
        end
      else
        -- Not chording and nothing pending; this was a tap:
        --
        --   Caps Lock *---------*
        --
        -- BUG: if previously were chording, bummer
        if deepEquals(flags, {}) then
          event.newKeyEvent({}, keyCodes[keyCode], true):
            setProperty(eventSourceUserData, injectedEvent):
            post()
        else
          return
        end
      end
      return stopPropagation
    end

    -- Again, check for active conditionals.
    for _, config in pairs(conditionalKeys) do
      if config.downAt then
        if config.isChording then
          while true do
            local pending = pendingEvents.dequeue()
            if pending then
              local injectedFlags = {}
              injectedFlags[config.chorded] = true
              pending:setFlags(injectedFlags):post()
            else
              break
            end
          end
        elseif when - config.downAt >= chordThreshold then
          -- Not chording and too late to start now. Allow it through
          while true do
            local pending = pendingEvents.dequeue()
            if pending then
              pending:post()
            else
              break
            end
          end
        elseif #pendingEvents > 0 then
          -- Not chording. Drain the queue and start chording.
          config.isChording = true
          local injectedFlags = {}
          injectedFlags[config.chorded] = true
          while true do
            local pending = pendingEvents.dequeue()
            if pending then
              pending:setFlags(injectedFlags):post()
            else
              break
            end
          end
        end
        return
      end
    end
  end
end)

local modifierTap = nil
local keyTap = nil
return {
  init = (function()
    modifierTap = retain(eventtap.new({types.flagsChanged}, modifierHandler):start())
    keyTap = retain(eventtap.new({keyDown, keyUp}, keyHandler):start())
  end),
  __debug = {
    conditionalKeys = conditionalKeys,
    pendingEvents = pendingEvents,
    getKeyTap = (function() return keyTap end),
    getModifierTap = (function() return modifierTap end),
  },
}
