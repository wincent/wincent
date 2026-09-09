local autocmd = require('wincent.nvim.autocmd')

-- TODO: rename files under ~/.zsh to use ".zsh" extensions, to obviate the need
-- for some of these patterns (not the autoloaded functions, because they have
-- to be extensionless).
vim.filetype.add({
  pattern = {
    -- Anything without a dot.
    ['.*/%.zsh/[^./]+'] = 'zsh',
    -- Anything without a dot, plus a ".private" extension.
    ['.*/%.zsh/[^/]+%.private'] = 'zsh',
    -- Anything without a dot under "functions.d/".
    ['.*/%.zsh/functions%.d/[^./]+'] = 'zsh',
    -- Anything without a dot under "host/".
    ['.*/%.zsh/host/[^./]+'] = 'zsh',
  },
})

-- Override built-in ftdetect which classifies this as "exports" (NFS) filetype.
autocmd('BufNewFile,BufRead', '*/.zsh/exports', 'set filetype=zsh')
