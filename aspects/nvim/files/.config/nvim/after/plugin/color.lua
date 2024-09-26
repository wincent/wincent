local augroup = wincent.vim.augroup
local autocmd = wincent.vim.autocmd

-- Convenience function so we don't have to escape input and pass it to
-- `:echoerr`.
local echoerr = function(msg)
  vim.api.nvim_err_writeln(msg)
end

local check = function()
  local has_pinnacle, pinnacle = pcall(require, 'wincent.pinnacle')
  if has_pinnacle then
    local config_file = vim.fn.expand('~/.zsh/.base16')

    if vim.fn.filereadable(config_file) then
      local scheme, background = unpack(vim.fn.readfile(config_file, '', 2))

      if background == 'dark' or background == 'light' then
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
      vim.cmd('colorscheme base16-classic-dark')
    end

    local dark = vim.o.background == 'dark'

    pinnacle.merge('Comment', { italic = true })

    -- Hide (or at least make less obvious) the EndOfBuffer region
    pinnacle.set('EndOfBuffer', {
      bg = 0,
      ctermbg = 0,
      ctermfg = 0,
      fg = 0,
    })

    -- Grey, just like we used to get with https://github.com/Yggdroot/indentLine
    if dark then
      pinnacle.set('Conceal', { ctermfg = 239, fg = 'Grey30' })
      pinnacle.merge('IndentBlanklineChar', { fg = 'Grey10', nocombine = true })
    else
      pinnacle.set('Conceal', { ctermfg = 249, fg = 'Grey30' })
      pinnacle.merge('IndentBlanklineChar', { fg = 'Grey30', nocombine = true })
    end

    pinnacle.link('NonText', 'Conceal')

    -- Copy rather than link, seeing as we mutate DiffText further down.
    pinnacle.set('CursorLineNr', pinnacle.dump('DiffText'))

    pinnacle.link('Pmenu', 'Visual')
    pinnacle.link('DiffDelete', 'Conceal')
    pinnacle.link('VertSplit', 'LineNr')

    -- Resolve clashes with ColorColumn.
    pinnacle.clear('vimUserFunc')

    -- See :help 'pb'.
    pinnacle.merge('PmenuSel', { blend = 0 })

    -- For Git commits, suppress the background of these groups:
    for _, group in ipairs({ 'DiffAdded', 'DiffFile', 'DiffNewFile', 'DiffLine', 'DiffRemoved' }) do
      local highlight = pinnacle.dump(group)
      highlight['bg'] = nil
      pinnacle.set(group, highlight)
    end

    -- More subtle highlighting during merge conflict resolution.
    pinnacle.clear('DiffAdd')
    pinnacle.clear('DiffChange')
    pinnacle.clear('DiffText')

    -- Make floating windows look nicer, as seen in wiki:
    -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
    local factor = dark and 0.1 or -0.1
    local normal = pinnacle.adjust_lightness('Normal', factor)
    pinnacle.set('NormalFloat', normal)
    normal['fg'] = dark and '#ffffff' or '#000000'
    normal['blend'] = vim.o.winblend
    pinnacle.set('FloatBorder', normal)

    -- Make undercurl color for misspelled words red instead of matching text.
    pinnacle.merge('SpellBad', { sp = 'Red' })

    local match = pinnacle.decorate({ 'underline', 'bold' }, 'PMenu')

    pinnacle.set('CmpItemAbbrMatch', match)
    pinnacle.set('CmpItemAbbrMatchFuzzy', match)

    -- Allow for overrides:
    -- - `lua/wincent/statusline.lua` will re-set User1, User3 etc.
    -- - `after/plugin/loupe.lua` will override Search, QuickFixLine.
    vim.cmd('doautocmd ColorScheme')
  end
end

if vim.v.progname ~= 'vi' then
  augroup('WincentAutocolor', function()
    autocmd('FocusGained', '*', check)

    -- Ideally we'd only do this outside of tmux (we don't get FocusGained
    -- events on launch outside of tmux), but we have to do it unconditionally
    -- because sometimes tmux doesn't get the events (for example, when Vim is
    -- launched in a non-focused pane via `tmux send-keys`). This means that
    -- we'll run twice (VimEnter, then FocusGained) when launched conventionally
    -- inside tmux. Each call to `check()` takes about 7ms on my work machine.
    autocmd('VimEnter', '*', check)
  end)
end
