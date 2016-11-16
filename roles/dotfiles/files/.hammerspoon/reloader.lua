--
-- Auto-reload config on change.
--

local function reloadConfig(files)
  local reload = false
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      reload = true
    end
  end
  if reload then
    -- TODO: publish a global event
    -- tearDownEventHandling()
    hs.reload()
  end
end

return {
  init = (function()
    hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
  end)
}
