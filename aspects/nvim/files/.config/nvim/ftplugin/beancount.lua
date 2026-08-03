local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
  cmp.setup.filetype('beancount', {
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'path' },

      -- Custom sources.
      {
        name = 'beancount',
        option = {
          account = vim.env.BEANCOUNT_FILE,
        },
      },
    }),
  })
end
