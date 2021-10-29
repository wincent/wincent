local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },

    sources = cmp.config.sources({
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'path' },
    })
  }

  cmp.setup.cmdline('/', {
    sources = {
      name = 'buffer'
    }
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end
