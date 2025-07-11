local autocmd = require('wincent.nvim.autocmd')

local function scan_file()
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

local function has_jsx_filetype()
  return vim.regex('\\v<jsx>'):match_str(vim.o.filetype)
end

local function set_jsx()
  if not has_jsx_filetype() then
    vim.cmd('noautocmd set filetype+=.jsx')
  end
end

local function detect_jsx()
  if has_jsx_filetype() then
    return
  end
  if scan_file() then
    set_jsx()
  end
end

autocmd('BufNewFile,BufRead', '*.js.jsx,*.jsx', set_jsx)
autocmd('BufNewFile,BufRead', '*.html,*.js', detect_jsx)
