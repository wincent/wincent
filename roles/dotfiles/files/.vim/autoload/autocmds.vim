" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
let g:WincentMkviewFiletypeBlacklist = ['hgcommit', 'gitcommit']

function! autocmds#should_mkview()
  return
        \ &buftype == '' &&
        \ index(g:WincentMkviewFiletypeBlacklist, &filetype) == -1
endfunction

function! autocmds#blur_statusline()
  if s:statusline_changes_allowed()
    setlocal statusline=%n:%<%f
  endif
endfunction

function! autocmds#focus_statusline()
  if s:statusline_changes_allowed()
    setlocal statusline=
  endif
endfunction

function! s:statusline_changes_allowed()
  if      &ft == 'diff' && bufname('%') == '__Gundo_Preview__' ||
        \ &ft == 'gundo' ||
        \ &ft == 'nerdtree' ||
        \ &ft == 'qf'
    return 0
  endif

  return 1
endfunction
