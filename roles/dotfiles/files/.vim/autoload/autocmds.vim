let g:WincentColorColumnBlacklist = ['diff', 'undotree', 'nerdtree', 'qf']
let g:WincentCursorlineBlacklist = ['command-t']
let g:WincentMkviewFiletypeBlacklist = ['diff', 'hgcommit', 'gitcommit']

function! autocmds#attempt_select_last_file() abort
  let l:previous=expand('#:t')
  if l:previous != ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

function! autocmds#should_colorcolumn() abort
  return index(g:WincentColorColumnBlacklist, &filetype) == -1
endfunction

function! autocmds#should_cursorline() abort
  return index(g:WincentCursorlineBlacklist, &filetype) == -1
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
function! autocmds#should_mkview() abort
  if exists('*haslocaldir') && haslocaldir()
    return 0
  else
    return
          \ &buftype == '' &&
          \ index(g:WincentMkviewFiletypeBlacklist, &filetype) == -1 &&
          \ !exists('$SUDO_USER') " Don't create root-owned files.
  endif
endfunction

function! autocmds#blur_statusline() abort
  " Default blurred statusline (buffer number: filename).
  let l:blurred='%#User2#' " higlight (same as MatchParens, plus italics)
  let l:blurred.='%{statusline#gutterpadding(0)}'
  let l:blurred.='\ ' " space
  let l:blurred.='%<' " truncation point
  let l:blurred.='%f' " filename
  let l:blurred.='%=' " split left/right halves (makes background cover whole)
  let l:blurred.='%*' " reset highlight
  call s:update_statusline(l:blurred, 'blur')
endfunction

function! autocmds#focus_statusline() abort
  " `setlocal statusline=` will revert to global 'statusline' setting.
  call s:update_statusline('', 'focus')
endfunction

function! s:update_statusline(default, action) abort
  let l:statusline = s:get_custom_statusline(a:action)
  if type(l:statusline) == type('')
    " Apply custom statusline.
    execute 'setlocal statusline=' . l:statusline
  elseif l:statusline == 0
    " Do nothing.
    "
    " Note that order matters here because of Vimscript's insane coercion rules:
    " when comparing a string to a number, the string gets coerced to 0, which
    " means that all strings `== 0`. So, we must check for string-ness first,
    " above.
    return
  else
    execute 'setlocal statusline=' . a:default
  endif
endfunction

function! s:get_custom_statusline(action) abort
  if &ft == 'command-t'
    " Will use Command-T-provided buffer name, but need to escape spaces.
    return '\ \ ' . substitute(bufname('%'), ' ', '\\ ', 'g')
  elseif &ft == 'diff' && bufname('%') == '__Gundo_Preview__'
    return 'Gundo\ Preview' " Less ugly, and nothing really useful to show.
  elseif &ft == 'gundo'
    return 'Gundo' " Less ugly, and nothing really useful to show.
  elseif &ft == 'nerdtree'
    return 0 " Don't override; NERDTree does its own thing.
  elseif &ft == 'qf'
    if a:action == 'blur'
      return 'Quickfix'
    else
      return g:WincentQuickfixStatusline
    endif
  endif

  return 1 " Use default.
endfunction
