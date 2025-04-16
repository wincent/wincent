local has_ibl, ibl = pcall(require, 'ibl')
if has_ibl then
  local custom_excluded_filetypes = { 'markdown' }
  local default_excluded_filetypes = require('ibl.config').default_config.exclude.filetypes
  local excluded_filetypes = {}
  vim.list_extend(excluded_filetypes, default_excluded_filetypes)
  vim.list_extend(excluded_filetypes, custom_excluded_filetypes)

  local function check_expandtab()
    if vim.o.expandtab and not vim.list_contains(excluded_filetypes, vim.o.filetype) then
      vim.cmd('IBLEnable')
    else
      vim.cmd('IBLDisable')
    end
  end

  ibl.setup({
    exclude = {
      -- These will get added to defaults (see `:h ibl.config.exclude`).
      filetypes = custom_excluded_filetypes,
    },
    indent = {
      char = '│',
    },
  })

  local group = vim.api.nvim_create_augroup('wincent.ibl', {})

  vim.api.nvim_create_autocmd('BufEnter', {
    callback = check_expandtab,
    group = group,
  })

  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'expandtab',
    callback = check_expandtab,
    group = group,
  })
end
