" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

if has('nvim')
  autocmd BufNewFile,BufRead *.md lua require'wincent.corpus.private.ftdetect'()
endif
