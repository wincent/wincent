local has_pinnacle, pinnacle = pcall(require, 'wincent.pinnacle')
if has_pinnacle then
  local augroup = require('wincent.nvim.augroup')
  augroup('wincent.loupe', function(autocmd)
    autocmd('ColorScheme', '*', function()
      pinnacle.link('QuickFixLine', 'PmenuSel')
      pinnacle.set('Search', pinnacle.embolden('Underlined'))
    end)
  end)
end
