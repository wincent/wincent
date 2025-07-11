local autocmd = require('wincent.nvim.autocmd')

-- Sneakily using "spec" for both RSpec and other "testy" file types.
autocmd('BufNewFile,BufRead', '*_spec.rb,*_test.rb', 'set filetype=ruby.spec')
