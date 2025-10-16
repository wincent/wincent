let s:source = {
      \ 'name' : 'ghc',
      \ 'kind' : 'ftplugin',
      \ 'filetypes': { 'haskell': 1, 'lhaskell': 1 },
      \ 'min_pattern_length' :
      \   g:neocomplete#auto_completion_start_length,
      \ 'input_pattern' : '^import\>.\{-}(\|[^. \t0-9]\.\w*',
      \ 'hooks' : {},
      \ }

function! s:source.hooks.on_init(context) abort
  call necoghc#boot()
endfunction

function! s:source.get_complete_position(context) abort
  if neocomplete#within_comment()
    return -1
  endif

  return necoghc#get_keyword_pos(a:context.input)
endfunction

function! s:source.gather_candidates(context) abort
  let line = getline('.')[: a:context.complete_pos]

  return necoghc#get_complete_words(
        \ a:context.complete_pos, a:context.complete_str)
endfunction

function! neocomplete#sources#ghc#define() abort
  if g:necoghc#executable ==# ''
    return {}
  endif

  return s:source
endfunction

" vim: ts=2 sw=2 sts=2 foldmethod=marker
