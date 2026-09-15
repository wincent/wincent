--- Opens a syntax-colored version of the current file in Chrome, suitable for
--- copy-pasting into a presentation.
local function keynote()
  -- Must be set before `:TOhtml` runs. It lived at the top of
  -- "autoload/wincent/functions.vim", which worked only because calling into
  -- the autoload file is what sourced it in the first place.
  vim.g.html_font = { 'Source Code Pro', 'Consolas', 'Monaco' }

  vim.opt_local.number = false
  vim.opt_local.relativenumber = false

  vim.cmd.packadd('nvim.tohtml')
  vim.cmd.TOhtml()

  -- Was `trim(system('mktemp'))`, which shelled out for something Neovim can do
  -- itself (and which created a file that `:saveas!` then had to overwrite).
  local tempfile = vim.fn.tempname() .. '.html'

  vim.notify(tempfile)

  vim.cmd('saveas! ' .. vim.fn.fnameescape(tempfile))
  vim.fn.system({ 'open', '-b', 'com.google.Chrome', tempfile })
  vim.cmd.quit()
end

return keynote
