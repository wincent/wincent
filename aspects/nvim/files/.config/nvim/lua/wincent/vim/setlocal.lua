-- This is a (probably) temporary workaround until:
--
--    https://github.com/neovim/neovim/issues/14670
--
-- is resolved.
--
-- Basically, Vim's `setlocal` is magical, sometimes operating as buffer-local
-- and at other times as window-local.

local options = {
  breakindent = {scope = 'window', type = 'boolean'},
  breakindentopt = {scope = 'window', type = 'string'},
  colorcolumn = {scope = 'window', type = 'string'},
  concealcursor = {scope = 'window', type = 'string'},
  expandtab = {scope = 'buffer', type = 'boolean'},
  foldenable = {scope = 'window', type = 'boolean'},
  formatprg = {scope = 'buffer', type = 'string'},
  iskeyword = {scope = 'buffer', type = 'list'},
  list = {scope = 'window', type = 'boolean'},
  modifiable = {scope = 'buffer', type = 'boolean'},
  omnifunc = {scope = 'buffer', type = 'string'},
  readonly = {scope = 'buffer', type = 'boolean'},
  shiftwidth = {scope = 'buffer', type = 'number'},
  smartindent = {scope = 'buffer', type = 'boolean'},
  spell = {scope = 'window', type = 'boolean'},
  spellfile = {scope = 'buffer', type = 'string'},
  spelllang = {scope = 'buffer', type = 'string'},
  statusline = {scope = 'window', type = 'string'},
  synmaxcol = {scope = 'buffer', type = 'number'},
  tabstop = {scope = 'buffer', type = 'number'},
  textwidth = {scope = 'buffer', type = 'number'},
  wrap = {scope = 'window', type = 'boolean'},
  wrapmargin = {scope = 'buffer', type = 'number'},
}

local bail = function(msg)
  vim.api.nvim_err_writeln(msg)
end

local setlocal = function(name, ...)
  local args = {...}
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

  local get = option.scope == 'buffer' and
    vim.api.nvim_buf_get_option or
    vim.api.nvim_win_get_option

  local set = option.scope == 'buffer' and
    vim.api.nvim_buf_set_option or
    vim.api.nvim_win_set_option

  if operator == '=' then
    set(0, name, value)
  elseif operator == '-=' then
    if option.type ~= 'list' then
      return bail('setlocal(): operator "-=" requires list type but got ' .. option.type)
    end
    local current = vim.split(get(0, name), ',')
    print('current ' .. vim.inspect(current))
    local new = vim.tbl_filter(function(item)
      return item ~= value
    end, current)
    set(0, name, wincent.util.join(new, ','))
  else
    return bail('setlocal(): unsupported operator: ' .. operator)
  end
end

return setlocal
