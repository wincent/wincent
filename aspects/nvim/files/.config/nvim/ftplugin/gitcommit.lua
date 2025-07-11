vim.opt_local.foldenable = false

require('wincent.nvim.spell')()

local has_cmp, cmp = pcall(require, 'cmp')
if has_cmp then
  -- Register custom sources.
  require('wincent.cmp.commits').setup() -- Git commit hashes; eg. abc123... → abc123 ("commit subject", 2025-01-01)
  require('wincent.cmp.handles').setup() -- GitHub handles; eg. @wincent → Greg Hurrell <greg.hurrell@datadoghq.com>

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'path' },

      -- Custom sources.
      { name = 'commits' },
      { name = 'handles' },
    }),
  })
end
