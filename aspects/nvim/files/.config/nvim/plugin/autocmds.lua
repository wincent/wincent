local augroup = wincent.vim.augroup
local autocmd = wincent.vim.autocmd

local autocmds = function ()
  augroup('WincentAutocmds', function ()
    autocmd('BufEnter', '*', wincent.autocmds.buf_enter)
    autocmd('BufFilePost,BufNewFile,BufReadPost', '*', 'call wincent#autocmds#apply_overrides()')
    autocmd('BufLeave', '?*', wincent.autocmds.buf_leave)
    autocmd('BufWinEnter', '?*', wincent.autocmds.buf_win_enter)
    autocmd('BufWritePost', '*', "call wincent#autocmds#encrypt(expand('<afile>:p'))")
    autocmd('BufWritePost', '*/spell/*.add', 'silent! :mkspell! %')
    autocmd('BufWritePost', '?*', wincent.autocmds.buf_write_post)
    autocmd('FocusGained', '*', wincent.autocmds.focus_gained)
    autocmd('FocusLost', '*', wincent.autocmds.focus_lost)
    autocmd('InsertEnter', '*', wincent.autocmds.insert_enter)
    autocmd('InsertLeave', '*', wincent.autocmds.insert_leave)
    autocmd('InsertLeave', '*', 'set nopaste')
    autocmd('TextYankPost', '*', "silent! lua vim.highlight.on_yank {higroup='Substitute', on_visual=false, timeout=200}")
    autocmd('VimEnter', '*', wincent.autocmds.vim_enter)
    autocmd('VimResized', '*', 'execute "normal! \\<c-w>="')
    autocmd('WinEnter', '*', wincent.autocmds.win_enter)
    autocmd('WinLeave', '*', wincent.autocmds.win_leave)
  end)
end

autocmds()

--
-- Goyo
--

local matchadd = nil
local settings = {}

local goyo_enter = function ()
  vim.cmd [[
    augroup WincentAutocmds
      autocmd!
    augroup END
    augroup! WincentAutocmds

    augroup WincentAutocolor
      autocmd!
    augroup END
    augroup! WincentAutocolor
  ]]

  settings = {
    showbreak = vim.o.showbreak,
    statusline = vim.o.statusline,
    cursorline = vim.wo.cursorline,
    showmode = vim.o.showmode,
  }

  vim.opt.showbreak = ''
  vim.opt.statusline = ' '
  vim.opt.cursorline = false
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.showmode = false

  if vim.env.TMUX ~= nil then
    vim.cmd 'silent !tmux set status off'
  end

  local nbsp=' '
  matchadd = vim.fn.matchadd('Error', nbsp)
  vim.api.nvim_buf_set_var(0, 'quitting', 0)
  vim.api.nvim_buf_set_var(0, 'quitting_bang', 0)

  autocmd('QuitPre', '<buffer>', 'let b:quitting = 1')
  vim.cmd 'cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!'

  if vim.env.TMUX ~= nil then
    autocmd('VimLeavePre', '*', function ()
      vim.cmd 'silent !tmux set status on'
    end)
  end
end

local goyo_leave = function ()
  local is_last_buffer = #vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)') == 1

  if vim.api.nvim_buf_get_var(0, 'quitting') == 1 and is_last_buffer then
    if vim.api.nvim_buf_get_var(0, 'quitting_bang') == 1 then
      vim.cmd 'qa!'
    else
      vim.cmd 'qa'
    end
  end

  for k, v in pairs(settings) do
    vim.opt[k] = v
  end

  if vim.env.TMUX ~= nil then
    vim.cmd 'silent !tmux set status on'
  end

  if matchadd ~= nil then
    vim.cmd [[
      try
        call matchdelete(matchadd)
      catch /./
        " Swallow.
      endtry
    ]]
    matchadd = nil
  end

  autocmds()
end

autocmd('User', 'GoyoEnter', goyo_enter, {bang = true})
autocmd('User', 'GoyoLeave', goyo_leave, {bang = true})
