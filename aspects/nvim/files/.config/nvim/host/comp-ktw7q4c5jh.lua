-- Host-specific overrides for comp-ktw7q4c5jh.
local has_corpus, corpus = pcall(require, 'wincent.corpus')
if has_corpus then
  corpus({
    bang_creation = true,
    directories = {
      ['~/Documents/Corporate/Corpus'] = {
        autocommit = true,
        autoreference = 1,
        autotitle = 1,
        base = './',
        referenceheader = 'References',
        tags = { 'corporate' },
        transform = 'local',
      },
      ['~/Documents/Personal/Corpus'] = {
        autocommit = false,
        autoreference = 1,
        autotitle = 1,
        base = './',
        referenceheader = 'References',
        tags = { 'personal' },
        transform = 'local',
      },
      ['~/code/masochist/content/content/wiki'] = {
        autocommit = false,
        autoreference = 1,
        autotitle = 1,
        base = '/wiki/',
        referenceheader = 'References',
        tags = { 'wiki' },
        transform = 'web',
      },
    },
    sort = 'stat',
  })
end

-- Pi vs sandbox workarounds.
--
-- Both `/edit-answer` and CTRL-g (edit prompt) both cause Neovim to print error
-- messages as it tries to write files under ~/.config/.
if vim.env.SHADOWFAX_SANDBOX_ACTIVE == '1' then
  -- Two ways of saying "Don't read/write the shadafile on entry/exit"
  -- (Normally, 'shada' includes "n~/.config/nvim/shada").
  vim.opt.shada = ''
  vim.opt.shadafile = 'NONE'

  -- Don't write an undofile for the buffer
  -- ('undodir' = "~/.config/nvim/undo//,.").
  vim.opt.undofile = false
end
