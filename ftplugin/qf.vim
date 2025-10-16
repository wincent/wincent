" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
" @option g:FerretQFOptions boolean 1
"
" Controls whether to set up setting overrides for |quickfix| windows. These are
" various settings, such as |norelativenumber|, |nolist| and |nowrap|, that are
" intended to make the |quickfix| window, which is typically very small relative
" to other windows, more usable.
"
" A full list of overridden settings can be found in |ferret-overrides|.
"
" To prevent the custom settings from being applied, set |g:FerretQFOptions|
" to 0:
"
" ```
" let g:FerretQFOptions=0
" ```
let s:options=get(g:, 'FerretQFOptions', 1)
if s:options
  setlocal nolist
  if exists('+relativenumber')
    setlocal norelativenumber
  endif
  setlocal nowrap
  setlocal number

  " Want to set scrolloff only for the qf window, but it is a
  " unavoidably global option for which `setlocal` behaves just like `set`.
  if !exists('s:original_scrolloff')
    let s:original_scrolloff=&scrolloff
  endif
  set scrolloff=0

  if has('autocmd')
    augroup FerretQF
      autocmd!
      autocmd BufLeave <buffer> execute 'set scrolloff=' . s:original_scrolloff
      autocmd BufEnter <buffer> set scrolloff=0 | setlocal nocursorline
    augroup END
  endif
endif

""
" @option g:FerretQFMap boolean 1
"
" Controls whether to set up mappings in the |quickfix| results window and
" |location-list| for deleting results. The mappings include:
"
" - `d` (|visual-mode|): delete visual selection
" - `dd` (|Normal-mode|): delete current line
" - `d`{motion} (|Normal-mode|): delete range indicated by {motion}
"
" To prevent these mappings from being set up, set to 0:
"
" ```
" let g:FerretQFMap=0
" ```
let s:map=get(g:, 'FerretQFMap', 1)
if s:map
  " Make it easy to remove entries from the quickfix listing or location-list.
  nnoremap <buffer> <silent> d :set operatorfunc=ferret#private#qf_delete_motion<CR>g@
  nnoremap <buffer> <silent> dd :call ferret#private#qf_delete()<CR>
  vnoremap <buffer> <silent> d :call ferret#private#qf_delete()<CR>
endif
