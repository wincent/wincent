function! necoghc#diagnostics#report() abort
  let l:debug_flag = get(g:, 'necoghc_debug', 0)
  if !l:debug_flag
    let g:necoghc_debug = 1
  endif

  echomsg 'Current filetype:' &l:filetype

  let l:ghc_mod_executable = executable('ghc-mod')
  let l:hhpc_executable = executable('hhpc')
  let l:executable = l:ghc_mod_executable || l:hhpc_executable
  echomsg 'ghc-mod is executable:' l:ghc_mod_executable
  echomsg 'hhpc-mod is executable:' l:hhpc_executable
  if !l:executable
    echomsg '  Your $PATH:' $PATH
  endif

  echomsg 'omnifunc:' &l:omnifunc
  echomsg 'neocomplete.vim:' exists(':NeoCompleteEnable')
  echomsg 'neocomplcache.vim:' exists(':NeoComplCacheEnable')
  echomsg 'YouCompleteMe:' exists(':YcmDebugInfo')

  try
    echomsg 'vimproc.vim:' vimproc#version()
  catch /^Vim\%((\a\+)\)\=:E117/
    echomsg 'vimproc.vim: not installed'
  endtry

  echomsg 'ghc-mod:' necoghc#ghc_mod_version()

  if &l:filetype !=# 'haskell'
    call s:error('Run this command in the buffer opening a Haskell file')
    return
  endif
  call necoghc#boot()
  echomsg 'Imported modules:' join(keys(necoghc#get_modules()), ', ')

  echomsg 'Number of symbols in Prelude:' len(necoghc#browse('Prelude'))

  if !l:debug_flag
    let g:necoghc_debug = 0
  endif
endfunction

function! s:error(msg) abort
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction
