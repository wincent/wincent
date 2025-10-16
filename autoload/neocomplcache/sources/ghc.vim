let s:source = {
      \ 'name' : 'ghc',
      \ 'kind' : 'ftplugin',
      \ 'filetypes': { 'haskell': 1 },
      \ }

function! s:source.initialize() abort
  call necoghc#boot()
endfunction

function! s:source.get_keyword_pos(cur_text) abort
  if neocomplcache#within_comment()
    return -1
  else
    return necoghc#get_keyword_pos(a:cur_text)
  endif
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) abort
  let l:line = getline('.')[0 : a:cur_keyword_pos]
  " force auto-completion on importing functions
  if neocomplcache#is_auto_complete() &&
        \ l:line !~# '^import\>.\{-}(' &&
        \ l:line !~# '^\s\+[[:alpha:],(]' &&
        \ len(a:cur_keyword_str) < g:neocomplcache_auto_completion_start_length
    return []
  endif

  return necoghc#get_complete_words(a:cur_keyword_pos, a:cur_keyword_str)
endfunction

function! neocomplcache#sources#ghc#define() abort
  if g:necoghc#executable ==# ''
    return {}
  endif
  return s:source
endfunction

" vim: ts=2 sw=2 sts=2 foldmethod=marker
