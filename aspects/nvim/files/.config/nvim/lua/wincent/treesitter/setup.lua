-- Map from parsers to filetypes.
local filetypes = {
  bash = 'sh',
  git_config = 'gitconfig',
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
        -- Not using treesitter indents until logic is settled: see:
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/7840
        -- vim.bo.indentexpr = 'v:lua.wincent.treesitter.indentexpr()'
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

  local has_treesitter_textobjects, treesitter_textobjects = pcall(require, 'nvim-treesitter-textobjects')
  if has_treesitter_textobjects then
    treesitter_textobjects.setup({
      select = {
        lookahead = true,
      },
    })

    for _, entry in ipairs(require('wincent.treesitter.textobjects')) do
      local mapping, textobject, desc = entry.mapping, entry.textobject, entry.desc
      vim.keymap.set({ 'x', 'o' }, mapping, function()
        require('nvim-treesitter-textobjects.select').select_textobject(textobject, 'textobjects')
      end, { desc = desc })
    end
  end
end

return setup
