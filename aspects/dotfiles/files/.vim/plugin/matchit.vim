if has('packages')
  if !has('nvim')
    packadd! matchit
  endif
else
  source $VIMRUNTIME/macros/matchit.vim
endif
