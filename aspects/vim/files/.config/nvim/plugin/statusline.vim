scriptencoding utf-8

if has('nvim')
  " We have to set this up before the call to
  " `'wincent.statusline'.set()`; if we delay setting it until
  " .config/nvim/plugin/settings.lua is evaluated, we get:
  "
  "   E5108: Error executing lua ~/.config/nvim/lua/wincent/statusline.lua:251:
  "   Vim(highlight):E421: Color name or number not recognized: ctermbg=#505050 ctermfg=#d0d0d0 gui=italic
  "
  lua vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal

  lua require'wincent.statusline'.set()

  augroup WincentStatusline
    autocmd!
    autocmd ColorScheme * lua require'wincent.statusline'.update_highlight()
    autocmd User FerretAsyncStart lua require'wincent.statusline'.async_start()
    autocmd User FerretAsyncFinish lua require'wincent.statusline'.async_finish()
    autocmd BufWinEnter,BufWritePost,FileWritePost,TextChanged,TextChangedI,WinEnter * lua require'wincent.statusline'.check_modified()
  augroup END
endif
