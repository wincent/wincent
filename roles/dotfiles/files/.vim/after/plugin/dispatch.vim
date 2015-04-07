augroup WincentDispatch
  autocmd!
  autocmd FileType ruby.spec let b:dispatch = 'bundle exec rspec %'
augroup END
