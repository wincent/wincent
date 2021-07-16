local autocmd = wincent.vim.autocmd

local scan_file = function()
  local n = 1
  local nmax = vim.fn.line('$')
  if vim.fn.line('$') > 500 then
    nmax = 500
  end
  while n < nmax do
    if vim.regex('\\v<React>'):match_str(vim.fn.getline(n)) then
      return true
    end
    n = n + 1
  end
  return false
end

local has_jsx_filetype = function()
  return vim.regex('\\v<jsx>'):match_str(vim.o.filetype)
end

local set_jsx = function()
  if not has_jsx_filetype() then
    vim.cmd('noautocmd set filetype+=.jsx')
  end
end

local detect_jsx = function()
  if has_jsx_filetype() then
    return
  end
  if scan_file() then
    set_jsx()
  end
end

autocmd('BufNewFile,BufRead', '*.js.jsx,*.jsx', set_jsx)
autocmd('BufNewFile,BufRead', '*.html,*.js', detect_jsx)
