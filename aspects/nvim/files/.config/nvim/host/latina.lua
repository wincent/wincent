-- Host-specific overrides for "latina".
local has_corpus, corpus = pcall(require, 'wincent.corpus')
if has_corpus then
  corpus({
    bang_creation = true,
    directories = {
      ['~/Documents/Corpus'] = {
        autocommit = true,
        autoreference = 1,
        autotitle = 1,
        base = './',
        transform = 'local',
      },
      ['~/Sync/greg.hurrell@datadoghq.com/worktree/Corpus'] = {
        autocommit = false,
        autoreference = 1,
        autotitle = 1,
        base = './',
        tags = { 'personal' },
        transform = 'local',
      },
      ['~/code/masochist/content/content/wiki'] = {
        autocommit = false,
        autoreference = 1,
        autotitle = 1,
        base = '/wiki/',
        tags = { 'wiki' },
        transform = 'web',
      },
    },
    sort = 'stat',
  })
end
