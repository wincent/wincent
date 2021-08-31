-- Sneakily using "spec" for both RSpec and other "testy" file types.
wincent.vim.autocmd('BufNewFile,BufRead', '*_spec.rb,*_test.rb', 'set filetype=ruby.spec')
