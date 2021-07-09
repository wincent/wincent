scriptencoding utf-8

if has('autocmd')
  function! s:WincentAutocmds()
    augroup WincentAutocmds
      autocmd!

      autocmd BufFilePost,BufNewFile,BufReadPost * call wincent#autocmds#apply_overrides()
      autocmd BufWritePost * call wincent#autocmds#encrypt(expand('<afile>:p'))
      autocmd BufWritePost */spell/*.add silent! :mkspell! %
      autocmd InsertLeave * set nopaste
      autocmd VimResized * execute "normal! \<c-w>="

      if exists('##TextYankPost')
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='Substitute', on_visual=false, timeout=200}
      endif
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
    if has('patch-7.3.544')
      autocmd QuitPre <buffer> let b:quitting=1
      cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    endif

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
endif
