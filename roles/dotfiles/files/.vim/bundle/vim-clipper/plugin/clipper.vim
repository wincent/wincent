" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:ClipperLoaded') || &compatible || v:version < 700
  finish
endif
let g:ClipperLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

command! Clip call clipper#private#clip()

let s:map = exists('g:ClipperMap') ? g:ClipperMap : 1
if s:map
  if !hasmapto('<Plug>ClipperClip') && maparg('<leader>y', 'n') ==# ''
    nmap <unique> <leader>y :Clip<CR>
  endif
endif
nnoremap <Plug>ClipperClip :Clip<CR>

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
