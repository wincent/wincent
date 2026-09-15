--- Opens a syntax-colored version of the current file in Chrome, suitable for
--- copy-pasting into a presentation.
local function keynote()
  vim.cmd.packadd('nvim.tohtml')

  -- The `:TOhtml` command gives us no way to pass options, so go through the
  -- API instead.
  --
  -- `font` matters because `g:html_font` (which this used to set) belonged to
  -- the old "tohtml.vim" and is ignored by "nvim.tohtml". Without it we'd fall
  -- back to parsing 'guifont', which yields a full font name ("MonoLisaCode
  -- ExtraLight Regular") rather than a family name, and so doesn't reliably
  -- match in a browser. A generic "monospace" is always appended for us.
  --
  -- No need to turn off 'number' first, as the old implementation did: line
  -- numbers are opt-in here via `number_lines`.
  local html = require('tohtml').tohtml(0, { font = 'MonoLisa' })

  -- Was `trim(system('mktemp'))`, which shelled out for something Neovim can do
  -- itself (and which created a file that `:saveas!` then had to overwrite).
  local tempfile = vim.fn.tempname() .. '.html'

  vim.fn.writefile(html, tempfile)

  vim.notify(tempfile)

  vim.fn.system({ 'open', '-b', 'com.google.Chrome', tempfile })
end

return keynote
