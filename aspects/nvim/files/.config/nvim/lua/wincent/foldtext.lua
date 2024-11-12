local middot = '·'
local raquo = '»'
local small_l = 'ℓ'

-- Override default `foldtext()`, which produces something like:
--
--   +---  2 lines: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
--
-- Instead returning:
--
--   »··[2ℓ]··: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
--
local foldtext = function()
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local lines = '[' .. line_count .. small_l .. ']'
  local first = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local tabs = first:match('^%s*'):gsub(' +', ''):len()
  local spaces = first:match('^%s*'):gsub('\t', ''):len()
  local indent = spaces + tabs * vim.bo.tabstop
  local stripped = first:match('^%s*(.-)$')
  local prefix = raquo .. middot .. middot .. lines
  local suffix = ': '

  -- Can't usefully use string.len() on UTF-8.
  local prefix_len = tostring(line_count):len() + 6

  local dash_count = math.max(indent - prefix_len - string.len(suffix), 0)
  local dashes = string.rep(middot, dash_count)
  return prefix .. dashes .. suffix .. stripped
end

return foldtext
