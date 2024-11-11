local has_ibl, ibl = pcall(require, 'ibl')
if has_ibl then
  ibl.setup({
    exclude = {
      filetypes = {
        -- In addition to defaults (see `:h ibl.config.exclude`).
        'markdown',
      },
    },
  })
end
