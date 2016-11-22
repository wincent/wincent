--
-- Trying to limp along without Karabiner in Sierra.
--

local deepEquals = require 'deepEquals'
local retain = require 'retain'
local queue = require 'queue'
local util = require 'util'

-- Forward function declarations.
local cancelTimers = nil
local modifierHandler = nil
local keyHandler = nil

local eventtap = hs.eventtap
local event = eventtap.event
local find = hs.fnutils.find
local types = event.types
local keyDown = types.keyDown
local keyUp = types.keyUp
local properties = event.properties
local eventSourceUserData = properties.eventSourceUserData
local keyboardEventAutorepeat = properties.keyboardEventAutorepeat
local keyCodes = hs.keycodes.map
local timer = hs.timer

-- Magic number chosen "at random" to tag an event injected by the tap which
-- should be ignored by the tap.
local injectedEvent = 94025

-- Magic number chosen "at random" to tag an event generated in a modifier
-- position (for example, Caps Lock -> mapped to Control in System Preferences ->
-- transformed into "delete", but tagged so as to distinguish it from a "real"
-- delete coming from elsewhere on the keyboard).
local modifierEvent = 94117

local stopPropagation = true -- For readability.

-- Key codes not present in hs.keycodes.map.
local extraKeyCodes = {
  leftControl = 59,
}
local controlPressed = nil
local repeatDelay = eventtap.keyRepeatDelay()
local repeatInterval = eventtap.keyRepeatInterval()
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
  local flags = evt:getFlags()
  local keyCode = evt:getKeyCode()

  -- Going to fire a fake delete key-press so that we can handle this in the
  -- keyHandler function along with return.
  if keyCode == extraKeyCodes.leftControl then
    -- We only start timers when Control is pressed alone, but we clean them up
    -- unconditionally when it is released, so as not to leak.
    if flags.ctrl == nil and controlPressed == true then
      controlPressed = false
      event.newKeyEvent({}, 'delete', false):
        setProperty(eventSourceUserData, modifierEvent):
        post()
      cancelTimers()
    elseif deepEquals(flags, {ctrl = true}) then
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
  end
end)

-- Straight-forward key-to-key mappings.
local mappings = {}
mappings[keyCodes.i] = {
  {
    flags = {ctrl = true},
    toKeyCode = 'f6',
    toFlags = {},
    apps = {
      'com.apple.Terminal',
      'com.googlecode.iterm2',
      'org.vim.MacVim',
    },
  },
}

-- These are keys that do one thing when tapped but act like modifiers when
-- chorded.
local conditionalKeys = {}
conditionalKeys[keyCodes.delete] = {
  tapped = 'delete',
  chorded = 'ctrl',
  downAt = nil,
  isChording = false,
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
  expectedFlags = {},
  expectedUserData = 0,
  rolloverThreshold = repeatDelay,
}
local pendingEvents = queue.create()

keyHandler = (function(evt)
  local userData = evt:getProperty(eventSourceUserData)
  if userData == injectedEvent then
    return
  end
  local eventType = evt:getType()
  local keyCode = evt:getKeyCode()
  local flags = evt:getFlags()
  local when = timer.secondsSinceEpoch()
  if eventType == keyDown then
    -- Deal with basic key-to-key mappings first.
    local mapping = mappings[keyCode] and find(mappings[keyCode], (function(mapping)
      return deepEquals(flags, mapping.flags)
    end))
    if mapping then
      local performMapping = true
      if mapping.apps then
        local frontmost = hs.application.frontmostApplication():bundleID()
        if not find(mapping.apps, (function(bundleID)
          return frontmost == bundleID
        end)) then
          performMapping = false
        end
      end
      if performMapping then
        event.newKeyEvent(mapping.toFlags, mapping.toKeyCode, true):
          setProperty(eventSourceUserData, injectedEvent):
          post()
        return stopPropagation
      end
    end

    -- Check for conditional keys.
    local config = conditionalKeys[keyCode]
    if config and config.expectedUserData == userData then
      if not config.downAt then
        config.downAt = when
      end

      -- TODO: consider edge case here around repeating event that maybe even
      -- be isChording, and then user presses another modifier and the next
      -- repeat event comes in
      if not deepEquals(flags, {}) or
        when - config.downAt > repeatDelay then
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
        elseif when - config.downAt < repeatDelay then
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
        elseif when - config.downAt >= repeatDelay then
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

return {
  init = (function()
    retain(eventtap.new({types.flagsChanged}, modifierHandler):start())
    retain(eventtap.new({keyDown, keyUp}, keyHandler):start())
  end),
}
