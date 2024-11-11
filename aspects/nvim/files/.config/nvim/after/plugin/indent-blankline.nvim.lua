local has_ibl, ibl = pcall(require, 'ibl')
if has_ibl then
  -- TODO: remove this `pcall` after Neovim v0.11 comes out; I'm temporarily
  -- adding it so that we can degrade gracefully if running on a
  -- not-sufficiently-recent v0.11 prerelease. See comment here:
  --
  -- - https://github.com/lukas-reineke/indent-blankline.nvim/commit/04e44b09ee3ff189c69ab082edac1ef7ae2e256c#diff-09ebcaa8c75cd1e92d25640e377ab261cfecaf8351c9689173fd36c2d0c23d94R22
  --
  -- and bug reports like the one with this reply:
  --
  -- - https://github.com/lukas-reineke/indent-blankline.nvim/issues/941#issuecomment-2466967518
  --
  pcall(function()
    ibl.setup({
      exclude = {
        filetypes = {
          -- In addition to defaults (see `:h ibl.config.exclude`).
          'markdown',
        },
      },
      indent = {
        char = '│',
      },
    })
  end)
end
