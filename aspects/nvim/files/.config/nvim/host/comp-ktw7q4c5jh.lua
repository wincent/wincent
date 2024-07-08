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
        transform = 'local',
      },
      ['~/Documents/Personal/Corpus'] = {
        autocommit = true,
        autoreference = 1,
        autotitle = 1,
        base = './',
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
