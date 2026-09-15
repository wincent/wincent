vim.filetype.add({
  pattern = {
    -- Anything without a dot under "functions.d/". These are autoloaded
    -- functions, so they have to be extensionless.
    ['.*/%.zsh/functions%.d/[^./]+'] = 'zsh',
  },
})
