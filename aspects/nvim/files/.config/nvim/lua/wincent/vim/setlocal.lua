-- This was originally a workaround due to buggy behavior of `vim.opt_local`:
--
--    https://github.com/neovim/neovim/issues/14670
--
-- That one is apparently resolved now, but I am leaving it as a convenience
-- wrapper in any case. Its job is to match the magical behavior of Vim's
-- `:setlocal` command, which can apply window-local or buffer-local settings,
-- even for settings like `'spell'` which are labeled as "window"-level settings
-- in the docs, but which actually need to be buffer-level ones in order to
-- provide a good user experience. `vim.api.nvim_buf_set_option()` errors if you
-- try to set `'spell'`, but `vim.api.nvim_set_option_value()` does not, and
-- it ends up setting it at a buffer level, not a window level, so we use that
-- here.

local options = {
  breakindent = { type = 'boolean' },
  breakindentopt = { type = 'string' },
  colorcolumn = { type = 'string' },
  concealcursor = { type = 'string' },
  expandtab = { type = 'boolean' },
  foldenable = { type = 'boolean' },
  formatprg = { type = 'string' },
  iskeyword = { type = 'list' },
  list = { type = 'boolean' },
  modifiable = { type = 'boolean' },
  omnifunc = { type = 'string' },
  readonly = { type = 'boolean' },
  shiftwidth = { type = 'number' },
  smartindent = { type = 'boolean' },
  spell = { type = 'boolean' },
  spellfile = { type = 'string' },
  spelllang = { type = 'string' },
  statusline = { type = 'string' },
  synmaxcol = { type = 'number' },
  tabstop = { type = 'number' },
  textwidth = { type = 'number' },
  wrap = { type = 'boolean' },
  wrapmargin = { type = 'number' },
}

local bail = function(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local setlocal = function(name, ...)
  local args = { ... }
  local operator = nil
  local value = nil
  if #args == 0 then
    operator = '='
    value = true
  elseif #args == 1 then
    operator = '='
    value = args[1]
  elseif #args == 2 then
    operator = args[1]
    value = args[2]
  else
    return bail('setlocal(): expects 1 or 2 arguments, got ' .. #args)
  end

  local option = options[name]
  if option == nil then
    return bail('setlocal(): unsupported option: ' .. name)
  end

  local get = function(name)
    return vim.api.nvim_get_option_value(name, { scope = 'local' })
  end

  local set = function(name, value)
    vim.api.nvim_set_option_value(name, value, { scope = 'local' })
  end

  if operator == '=' then
    set(name, value)
  elseif operator == '-=' then
    if option.type ~= 'list' then
      return bail('setlocal(): operator "-=" requires list type but got ' .. option.type)
    end
    local current = vim.split(get(name), ',')
    local new = vim.tbl_filter(function(item)
      return item ~= value
    end, current)
    set(name, wincent.util.join(new, ','))
  else
    return bail('setlocal(): unsupported operator: ' .. operator)
  end
end

return setlocal
