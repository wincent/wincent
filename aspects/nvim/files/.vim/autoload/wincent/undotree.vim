function! wincent#undotree#init() abort
  let g:undotree_HighlightChangedText=0
  let g:undotree_SetFocusWhenToggle=1
  let g:undotree_WindowLayout=2
  let g:undotree_DiffCommand='diff -u'
endfunction

" Mappings to emulate Gundo behavior.
function! g:Undotree_CustomMap() abort
  " Normally j, k just move and J, K actually revert; lets make j, k revert too.
  nmap <buffer> j <Plug>UndotreeGoPreviousState
  nmap <buffer> k <Plug>UndotreeGoNextState

  " Equivalent to `g:gundo_close_on_revert=1`:
  nmap <buffer> <Return> <Plug>UndotreeClose
endfunction
