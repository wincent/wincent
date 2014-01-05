augroup wincent_dispatch
  autocmd!
  autocmd FileType ruby.spec let b:dispatch = 'bundle exec rspec %'
augroup END
