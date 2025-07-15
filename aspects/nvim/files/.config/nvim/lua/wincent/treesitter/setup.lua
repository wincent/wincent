-- Map from parsers to filetypes.
local filetypes = {
  git_config = 'gitconfig',
  gitignore = 'ignore',
  markdown_inline = 'markdown',
  query = 'scheme',
  ssh_config = 'sshconfig',
  vimdoc = 'help',
}

local function setup(config)
  require('wincent.treesitter.config').set(config)

  -- Convert parser names to filetypes:
  local pattern = {}
  for _, parser in ipairs(config.parsers) do
    if filetypes[parser] then
      pattern[filetypes[parser]] = true
    else
      pattern[parser] = true
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = table.concat(vim.tbl_keys(pattern), ','),
    callback = function(data)
      if not require('wincent.nvim.is_large_buffer')(data.buf) then
        vim.bo.indentexpr = 'v:lua.wincent.treesitter.indentexpr()'
        vim.treesitter.start()
      end
    end,
  })

  -- TODO: incremental selection: used to configure this with:
  --
  --     incremental_selection = {
  --       -- gnn = init selection
  --       -- grn = node incremental
  --       -- grc = scope incremental
  --       -- grm = node decremental
  --       -- See: `:h nvim-treesitter-incremental-selection-mod`
  --       enable = true,
  --       disable = function(_lang, buffer)
  --         if require('wincent.nvim.is_large_buffer')(buffer) then
  --           -- Equivalent to :TSBufDisable incremental_selection.
  --           return true
  --         end
  --       end,
  --     },

  -- TODO: text objects: used to configure this with:
  --
  --
  --     textobjects = {
  --       select = {
  --         enable = true,
  --         disable = function(_lang, buffer)
  --           if require('wincent.nvim.is_large_buffer')(buffer) then
  --             return true
  --           end
  --         end,
  --         keymaps = {
  --           -- Similar to vim-textobj-comment: https://github.com/glts/vim-textobj-comment/
  --           ['ac'] = { query = '@comment.outer', desc = 'Select outer part of a comment region' },
  --           ['ic'] = { query = '@comment.inner', desc = 'Select inner part of a comment region' },

  --           ['af'] = { query = '@function.outer', desc = 'Select outer part of a function region' },
  --           ['if'] = { query = '@function.inner', desc = 'Select inner part of a function region' },

  --           ['ak'] = { query = '@class.outer', desc = 'Select outer part of a class region' },
  --           ['ik'] = { query = '@class.inner', desc = 'Select inner part of a class region' },

  --           ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop region' },
  --           ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop region' },

  --           -- Equivalent of vim-textobj-rubyblock: https://github.com/nelstrom/vim-textobj-rubyblock
  --           ['ar'] = { query = '@block.outer', desc = 'Select language scope' },
  --           ['ir'] = { query = '@block.inner', desc = 'Select language scope' },

  --           ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
  --         },
  --         lookahead = true,
  --       },
  --     },
end

return setup
