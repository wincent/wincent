local autocmd = require('wincent.nvim.autocmd')

local function has_tsx_filetype()
  return vim.regex('\\v<tsx>'):match_str(vim.o.filetype)
end

local function set_tsx()
  if not has_tsx_filetype() then
    vim.cmd('noautocmd set filetype+=.tsx')
  end
end

autocmd('BufNewFile,BufRead', '*.tsx', set_tsx)
