hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.window.animationDuration = 0 -- disable animations

local lastSeenChain = nil
local lastSeenWindow = nil

function chain(movements)
  local chainResetInterval = 2000
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    -- elseif (sequenceNumber == cycleLength) then
    -- TODO: at end of chain, restart chain on next screen
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber])
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

hs.hotkey.bind({'ctrl', 'alt'}, 'up', chain({
  '0,0 12x6', -- top half
  '0,0 12x4', -- top third
  '0,0 12x8', -- top two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'right', chain({
  '6,0 6x12', -- right half
  '8,0 4x12', -- right third
  '4,0 8x12', -- right two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'down', chain({
  '0,6 12x6', -- bottom half
  '0,8 12x4', -- bottom third
  '0,4 12x8', -- bottom two thirds
}))
hs.hotkey.bind({'ctrl', 'alt'}, 'left', chain({
  '0,0 6x12', -- left half
  '0,0 4x12', -- left third
  '0,0 8x12', -- left two thirds
}))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'up', chain({
  '0,0 6x6', -- top-left corner
  '6,0 6x6', -- top-right corner
  '6,6 6x6', -- bottom-right corner
  '0,6 6x6', -- bottom-left corner
}))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'down', chain({
  '0,0 12x12', -- full screen
  '3,3 6x6', -- centered, big
  '4,4 4x4', -- centered, small
}))
