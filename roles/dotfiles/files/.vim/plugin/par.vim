if &formatprg ==# '' && executable('par')
  " This will mostly do the right thing, although it ignores `'textwidth'` so
  " may want to set up an autocmd do adjust it based on that. In the meantime,
  " can use `gw`/`gww` whenever `gq`/`gqq` does the wrong thing.
  set formatprg=par\ rTbgqR\ B=.,\\?_A_a_0\ Q=_s\\>
endif
