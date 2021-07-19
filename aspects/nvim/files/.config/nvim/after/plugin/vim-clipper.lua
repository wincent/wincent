if vim.g.ClipperLoaded == 1 then
  vim.g.ClipperAddress = '~/.clipper.sock'
  vim.g.ClipperPort = 0

  if vim.fn.filereadable('/etc/arch-release') == 1 and vim.fn.executable('socat') == 1 then
    vim.fn['clipper#set_invocation']('socat - UNIX-CLIENT:' .. vim.fn.expand(vim.g.ClipperAddress))
  elseif vim.fn.filereadable('/etc/debian_version') == 1 and vim.fn.executable('socat') == 1 then
    vim.fn['clipper#set_invocation']('socat - UNIX-CLIENT:' .. vim.fn.expand(vim.g.ClipperAddress))
  else
    vim.fn['clipper#set_invocation']('')
  end
end
