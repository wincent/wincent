--[[

# Eventtap module

## Basic handling

In a perfect world, we'd only have two scenarios for key presses:

**Chorded combinations:** User holds down a modifier, and while it is down,
presses and releases another key. For example, to clear the terminal
(Control-L):

    Control *--------------*
          L       *----*

**Normal typing:** User presses and releases one key after another. For example,
to type "BAR":

          B *----*
          A         *----*
          R                 *----*

In practice, reality is more complicated. Users typing quickly typically engage
in "roll-over" in which successive keys are pressed before the preceding key is
released:

          B *----*
          A     *----*
          R         *----*

This also happens for chorded combinations. The user may be have the mental
model of "hold down a modifier, and while it is down, press and release another
key", but in reality many instances of this end up being roll-over scenarios
too:

    Control *----*
          L     *----*

This becomes a problem for us here where we have multi-role "conditional" keys,
that should be:

1. One key (such as "Backspace" or "Enter") when tapped.
2. That key, repeated, when pressed and held.
3. A modifier (such as "Control") when chorded with another key.

Give such a key, how are we to distinguish between these two cases?

      Control *----*
            L     *----*

    Backspace *----*
            L     *----*

The same keys are pressed, with the same timing, but in one case the user
intends to chord a combination and in the other he/she intends to delete a
character and type another.

Based on logging millisecond-level timing information and observing my own
typing, I've found that most chording events happen in the 70-200ms range (that
is, time elapsed between the modifier going down and the companion key going
down). The key repeat delay is ~416ms, and the repeat interval is ~33ms.

The heuristic applied here, then, is that if a key follows a potential modifier
by less than a threshold of 200ms, we assume that the user intends to chord and
fire the combination immediately. This matches the behavior of normal modifier
keys, which fire their combination immediately upon key-down.

If the threshold is exceeded, but still less than the repeat delay (416ms), we
put the event into a pending queue so that we can decide whether it is a chord
or a roll-over based on when key-up (or an autorepeating key-down) arrives. If
we see a key-up event before 416ms, we consider this to be a tap (ie. we assume
roll-over rather than a chord). The risk of a false positive here is not too
concerning: worst that can happen is we wind up doing something like
"Backspace-then-insert-space", which is generally unlikely to be a destructive
operation. In a nut-shell: the essence of this heuristic is that, for these
special keys:

- The very fastest rollovers are likely to be chording attempts.
- For not-quite-as-fast rollovers, we assume tap attempts, to make it possible
  for the user to do quick erase then insert.
- It's always possible to force a chording interpetation by doing a strict
  chord, in which the other key is released before the modifier
  (notwithstanding the fact that pressing and holding the modifier for long
  enough without explictly initiating a chord or a rollover will trigger an
  autorepeating tap).

This level of nuance is almost certainly overkill, but the ability to enqueue
pending events will come in handy when we come to implement the SpaceFN layout,
when it will be absolutely necessary to block processing until we see key-up.

The threshold is customizable, so I have it tuned very fast on the "Caps Lock"
side, where I tend to do very fast inwards rolls, while on the "Return" side I
opt for a higher threshold matching the repeat delay (416ms). This means that
any press within that window is considered a chord. It's possible that this is
too sensitive, making it harder to type fast roll-over sequences involving
"Return-followed-by-something-else".

## SpaceFN layout

When I implement this layer, things are going to get more complicated.
In the basic case, we must support this:

    Space *----*
        N      *----*

That is, fast typing with frequent rollover (very common when using the space
key), but also:

    Space *-----------*
        N      *----*

That is, the intent to activate the SpaceFN layer, meaning that we have to defer
emitting the space until we've seen the key-up event from the "N" key (subject
to a time out).

So far, that's definitely within the realm of the straighforwardly
implementable, but bear in mind that we will want to deal with modifiers as
well. For example, consider that we want to move back a word by doing
"Option-Space-N":

    Option *---------------*
     Space   *------------*
         N         *---*

Again, not too bad, but consider when we want to combine this with a
multi-purpose key again:

   Caps Lock *-----------------*
       Space    *-------------*
           N           *----*

This might be a little tricky to reconcile with my use of Control-Space as my
tmux prefix.

--]]

local deepEquals = require 'deepEquals'
local retain = require 'retain'
local queue = require 'queue'

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

local controlPressed = nil
local repeatDelay = eventtap.keyRepeatDelay() * 2
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
  -- keyHandler function along with return. Note the "ctrl" here is left
  -- control (we don't need any special handling for "rightctrl").
  if keyCode == keyCodes.ctrl then
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
      if (
        deepEquals(flags, {}) and
        (config.isChording or when - config.downAt < repeatDelay)
      ) then
        return stopPropagation
      end
      return
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
        end

        -- Note the simplifying assumption: guaranteed to `return` if we found
        -- an active conditional; we'll just take that one (ie. first wins;
        -- could also consider latest wins).
        return
      end
    end
  elseif eventType == keyUp then
    local config = conditionalKeys[keyCode]
    if config and config.expectedUserData == userData then
      config.downAt = nil
      if config.isChording then
        config.isChording = false
      else
        -- Not chording and we had something pending (user is typing fast):
        -- flush it!
        --
        --   Caps Lock *---------*
        --   X              *------*
        --
        -- And if nothing pending; this was a tap:
        --
        --   Caps Lock *---------*
        --
        if deepEquals(flags, {}) then
          event.newKeyEvent(flags, config.tapped, true):
            setProperty(eventSourceUserData, injectedEvent):
            post()
        end
        while true do
          local pending = pendingEvents.dequeue()
          if pending then
            pending:setFlags({}):post()
          else
            break
          end
        end
      end
      return
    end

    -- Again, check for active conditionals.
    for _, config in pairs(conditionalKeys) do
      if config.downAt then
        local injectedFlags = {}
        if config.isChording or #pendingEvents > 0 then
          config.isChording = true
          injectedFlags[config.chorded] = true
        end
        while true do
          local pending = pendingEvents.dequeue()
          if pending then
            pending:setFlags(injectedFlags):post()
          else
            break
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
