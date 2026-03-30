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

    -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@comment.outer', 'textobjects')
    end, { desc = 'Select outer part of a comment region' })
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@comment.inner', 'textobjects')
    end, { desc = 'Select inner part of a comment region' })
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Select outer part of a function region' })
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Select inner part of a function region' })
    vim.keymap.set({ 'x', 'o' }, 'ak', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
    end, { desc = 'Select outer part of a class region' })
    vim.keymap.set({ 'x', 'o' }, 'ik', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
    end, { desc = 'Select inner part of a class region' })
    vim.keymap.set({ 'x', 'o' }, 'al', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects')
    end, { desc = 'Select outer part of a loop region' })
    vim.keymap.set({ 'x', 'o' }, 'il', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects')
    end, { desc = 'Select inner part of a loop region' })
    vim.keymap.set({ 'x', 'o' }, 'ar', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@blook.outer', 'textobjects')
    end, { desc = 'Select outer part of a block region' })
    vim.keymap.set({ 'x', 'o' }, 'ir', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects')
    end, { desc = 'Select inner part of a block region' })
  end
end

return setup
