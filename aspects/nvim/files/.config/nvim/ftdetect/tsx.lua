local has_tsx_filetype = function()
  return vim.regex('\\v<tsx>'):match_str(vim.o.filetype)
end

local set_tsx = function()
  if not has_tsx_filetype() then
    vim.cmd('noautocmd set filetype+=.tsx')
  end
end

wincent.vim.autocmd('BufNewFile,BufRead', '*.tsx', set_tsx)
