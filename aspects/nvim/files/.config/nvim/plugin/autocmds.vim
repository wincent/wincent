scriptencoding utf-8

function! s:WincentAutocmds()
  augroup WincentAutocmds
    autocmd!
    autocmd BufEnter * lua wincent.autocmds.buf_enter()
    autocmd BufFilePost,BufNewFile,BufReadPost * call wincent#autocmds#apply_overrides()
    autocmd BufLeave ?* lua wincent.autocmds.buf_leave()
    autocmd BufWinEnter ?* lua wincent.autocmds.buf_win_enter()
    autocmd BufWritePost * call wincent#autocmds#encrypt(expand('<afile>:p'))
    autocmd BufWritePost */spell/*.add silent! :mkspell! %
    autocmd BufWritePost ?* lua wincent.autocmds.buf_write_post()
    autocmd FocusGained * lua wincent.autocmds.focus_gained()
    autocmd FocusLost * lua wincent.autocmds.focus_lost()
    autocmd InsertEnter * lua wincent.autocmds.insert_enter()
    autocmd InsertLeave * lua wincent.autocmds.insert_leave()
    autocmd InsertLeave * set nopaste
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='Substitute', on_visual=false, timeout=200}
    autocmd VimEnter * lua wincent.autocmds.vim_enter()
    autocmd VimResized * execute "normal! \<c-w>="
    autocmd WinEnter * lua wincent.autocmds.win_enter()
    autocmd WinLeave * lua wincent.autocmds.win_leave()
  augroup END
endfunction

call s:WincentAutocmds()

" Wait until idle to run additional "boot" commands.
augroup WincentIdleboot
  autocmd!
  if has('vim_starting')
    autocmd CursorHold,CursorHoldI * call wincent#autocmds#idleboot()
  endif
augroup END


"
" Goyo
"

let s:matchadd=v:null
let s:settings={}

function! s:goyo_enter()
  augroup WincentAutocmds
    autocmd!
  augroup END
  augroup! WincentAutocmds

  augroup WincentAutocolor
    autocmd!
  augroup END
  augroup! WincentAutocolor

  let s:settings = {
        \   'showbreak': &showbreak,
        \   'statusline': &statusline,
        \   'cursorline': &cursorline,
        \   'showmode': &showmode
        \ }

  set showbreak=
  set statusline=\ 
  set nocursorline
  set nonumber
  set norelativenumber
  set noshowmode

  if exists('$TMUX')
    silent !tmux set status off
  endif

  let l:nbsp=' '
  let s:matchadd=matchadd('Error', l:nbsp)
  let b:quitting=0
  let b:quitting_bang=0

  autocmd QuitPre <buffer> let b:quitting=1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!

  if exists('$TMUX')
    autocmd VimLeavePre * call s:EnsureTmux()
  endif
endfunction

function! s:EnsureTmux()
  silent !tmux set status on
endfunction

function! s:goyo_leave()
  let l:is_last_buffer=len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
  if b:quitting && l:is_last_buffer
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif

  for [k, v] in items(s:settings)
    execute 'let &' . k . '=' . string(v)
  endfor

  if exists('$TMUX')
    silent !tmux set status on
  endif

  if type(s:matchadd) != type(v:null)
    try
      call matchdelete(s:matchadd)
    catch /./
      " Swallow.
    endtry
    let s:matchadd=v:null
  endif

  call s:WincentAutocmds()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
