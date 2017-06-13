let g:WincentColorColumnBlacklist = ['diff', 'undotree', 'nerdtree', 'qf']
let g:WincentCursorlineBlacklist = ['command-t']
let g:WincentMkviewFiletypeBlacklist = ['diff', 'hgcommit', 'gitcommit']

function! wincent#autocmds#attempt_select_last_file() abort
  let l:previous=expand('#:t')
  if l:previous != ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

function! wincent#autocmds#should_colorcolumn() abort
  return index(g:WincentColorColumnBlacklist, &filetype) == -1
endfunction

function! wincent#autocmds#should_cursorline() abort
  return index(g:WincentCursorlineBlacklist, &filetype) == -1
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
function! wincent#autocmds#should_mkview() abort
  return
        \ &buftype == '' &&
        \ index(g:WincentMkviewFiletypeBlacklist, &filetype) == -1 &&
        \ !exists('$SUDO_USER') " Don't create root-owned files.
endfunction

function! wincent#autocmds#mkview() abort
  if exists('*haslocaldir') && haslocaldir()
    " We never want to save an :lcd command, so hack around it...
    cd -
    mkview
    lcd -
  else
    mkview
  endif
endfunction

function! wincent#autocmds#blur_window() abort
  if wincent#autocmds#should_colorcolumn()
    if !exists('w:wincent_matches')
      " Instead of unconditionally resetting, append to existing array.
      " This allows us to gracefully handle duplicate autocmds.
      let w:wincent_matches=[]
    endif
    let l:height=&lines
    let l:slop=l:height / 2
    let l:start=max([1, line('w0') - l:slop])
    let l:end=min([line('$'), line('w$') + l:slop])
    while l:start <= l:end
      let l:next=l:start + 8
      let l:id=matchaddpos(
            \   'StatusLine',
            \   range(l:start, min([l:end, l:next])),
            \   0
            \ )
      call add(w:wincent_matches, l:id)
      let l:start=l:next
    endwhile
  endif
endfunction

function! wincent#autocmds#focus_window() abort
  if wincent#autocmds#should_colorcolumn()
    if exists('w:wincent_matches')
      for l:match in w:wincent_matches
        try
          call matchdelete(l:match)
        catch /.*/
          " In testing, not getting any error here, but being ultra-cautious.
        endtry
      endfor
      let w:wincent_matches=[]
    endif
  endif
endfunction

function! wincent#autocmds#blur_statusline() abort
  " Default blurred statusline (buffer number: filename).
  let l:blurred='%{wincent#statusline#gutterpadding()}'
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='%<' " truncation point
  let l:blurred.='%f' " filename
  let l:blurred.='%=' " split left/right halves (makes background cover whole)
  call s:update_statusline(l:blurred, 'blur')
endfunction

function! wincent#autocmds#focus_statusline() abort
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
  elseif &ft == 'diff' && exists('t:diffpanel') && t:diffpanel.bufname == bufname('%')
    return 'Undotree\ preview' " Less ugly, and nothing really useful to show.
  elseif &ft == 'undotree'
    return 0 " Don't override; undotree does its own thing.
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

function! wincent#autocmds#idleboot() abort
  " Make sure we automatically call wincent#autocmds#idleboot() only once.
  augroup WincentIdleboot
    autocmd!
  augroup END

  " Make sure we run deferred tasks exactly once.
  doautocmd User WincentDefer
  autocmd! User WincentDefer
endfunction

" Directories where we want to perform auto-encryption on save.
let s:encrypted={}
let s:encrypted[expand('~/code/ansible-configs')]='vendor/git-cipher/bin/git-cipher'
let s:encrypted[expand('~/code/wincent')]='vendor/git-cipher/bin/git-cipher'

" Update encryptable files after saving.
function! wincent#autocmds#encrypt(file) abort
  let l:base=fnamemodify(a:file, ':h')
  let l:directories=keys(s:encrypted)
  for l:directory in l:directories
    if stridx(a:file, l:directory) == 0
      let l:encrypted=l:base . '/.' . fnamemodify(a:file, ':t') . '.encrypted'
      if filewritable(l:encrypted) == 1
        let l:executable=l:directory . '/' . s:encrypted[l:directory]
        if executable(l:executable)
          call system(
                \   fnamemodify(l:executable, ':S') .
                \   ' encrypt ' .
                \   shellescape(a:file)
                \ )
        endif
      endif
      break
    endif
  endfor
endfunction
