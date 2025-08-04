local once = require('wincent.once')

local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
  -- Stop nvim-cmp from showing autocomplete popup while typing into
  -- CommandTPrompt window.
  once(function()
    cmp.setup.filetype('CommandTPrompt', {
      sources = cmp.config.sources({}),
    })
  end, { key = 'cmp-setup-filetype.CommandTPrompt' })
end
