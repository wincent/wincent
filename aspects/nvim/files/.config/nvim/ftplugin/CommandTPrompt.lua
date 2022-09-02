-- Stop nvim-cmp from showing autocomplete popup while typing into
-- CommandTPrompt window.

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then
  return
end

if not wincent.g.CommandTPrompt then
  wincent.g.CommandTPrompt = { registered = true }
  cmp.setup.filetype('CommandTPrompt', {
    sources = cmp.config.sources({}),
  })
end
