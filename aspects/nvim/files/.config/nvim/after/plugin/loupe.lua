local has_pinnacle, pinnacle = pcall(require, 'wincent.pinnacle')
if has_pinnacle then
  wincent.vim.augroup('WincentLoupe', function(autocmd)
    autocmd('ColorScheme', '*', function()
      pinnacle.link('QuickFixLine', 'PmenuSel')
      pinnacle.set('Search', pinnacle.embolden('Underlined'))
    end)
  end)
end
