local augroup = wincent.vim.augroup
local autocmd = wincent.vim.autocmd

-- Convenience function so we don't have to escape input and pass it to
-- `:echoerr`.
local echoerr = function (msg)
  vim.api.nvim_err_writeln(msg)
end

local check = function ()
  local pinnacle = require'wincent.pinnacle'
  local config_file = vim.fn.expand('~/.zsh/.base16')

  if vim.fn.filereadable(config_file) then
    local scheme, background = unpack(vim.fn.readfile(config_file, '', 2))

    if background =='dark' or background == 'light' then
      vim.opt.background = background
    else
      echoerr('Bad background ' .. background .. ' in ' .. config_file)
    end

    if vim.fn.filereadable(vim.fn.expand('~/.config/nvim/colors/base16-' .. scheme .. '.lua')) then
      vim.cmd('colorscheme base16-' .. scheme)
    else
      echoerr('Bad scheme ' .. scheme .. ' in ' .. config_file)
    end
  else -- default
    vim.opt.background = 'dark'
    vim.cmd('colorscheme base16-bright')
  end

  vim.cmd('highlight Comment ' .. pinnacle.italicize('Comment'))

  -- Hide (or at least make less obvious) the EndOfBuffer region
  vim.cmd('highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg')

  -- Grey, just like we used to get with https://github.com/Yggdroot/indentLine
  vim.cmd('highlight clear Conceal')
  if vim.o.background == 'light' then
    vim.cmd('highlight Conceal ctermfg=249 guifg=Grey70')
    vim.cmd('highlight IndentBlanklineChar guifg=Grey90 gui=nocombine')
  else
    vim.cmd('highlight Conceal ctermfg=239 guifg=Grey30')
    vim.cmd('highlight IndentBlanklineChar guifg=Grey10 gui=nocombine')
  end

  vim.cmd [[
    highlight clear NonText
    highlight link NonText Conceal
    highlight clear CursorLineNr
  ]]
  vim.cmd('highlight CursorLineNr ' .. pinnacle.extract_highlight('DiffText'))
  vim.cmd [[
    highlight clear Pmenu
    highlight link Pmenu Visual

    " See :help 'pb'.
    highlight PmenuSel blend=0

    highlight clear DiffDelete
    highlight link DiffDelete Conceal
    highlight clear VertSplit
    highlight link VertSplit LineNr

    " Resolve clashes with ColorColumn.
    " Instead of linking to Normal (which has a higher priority, link to nothing).
    highlight link vimUserFunc NONE
  ]]

  -- For Git commits, suppress the background of these groups:
  for _, group in ipairs({'DiffAdded', 'DiffFile', 'DiffNewFile', 'DiffLine', 'DiffRemoved'}) do
    local highlight = pinnacle.dump(group)
    highlight['bg'] = nil
    vim.cmd('highlight! clear ' .. group)
    vim.cmd('highlight! ' .. group .. ' ' .. pinnacle.highlight(highlight))
  end

  -- More subtle highlighting during merge conflict resolution.
  vim.cmd [[
    highlight clear DiffAdd
    highlight clear DiffChange
    highlight clear DiffText
  ]]

  vim.cmd('highlight User8 ' .. pinnacle.italicize('ModeMsg'))

  -- Allow for overrides:
  -- - `lua/wincent/statusline.lua` will re-set User1, User2 etc.
  -- - `after/plugin/loupe.lua` will override Search.
  vim.cmd('doautocmd ColorScheme')
end

if vim.v.progname ~= 'vi' then
  augroup('WincentAutocolor', function ()
    autocmd('FocusGained', '*', check)
  end)

  -- This is not all roses... some things stop FocusGained from running; like a
  -- .tmux script that keeps focus away from Vim... should defer a check anyway;
  -- if we don't get a call in, say, 250ms... call!
  if vim.fn.exists('$TMUX') == 0 then
    -- In tmux we're going to get a `FocusGained` event on launch, but not when
    -- outside of it.
    check()
  end
end
