scriptencoding utf-8

if has('autocmd')
  function! s:WincentAutocmds()
    augroup WincentAutocmds
      autocmd!

      autocmd VimResized * execute "normal! \<c-w>="

      " Disable paste mode on leaving insert mode.
      autocmd InsertLeave * set nopaste

      if exists('+colorcolumn') &&
            \ exists('+winhighlight') &&
            \ has('conceal') &&
            \ has('folding') &&
            \ has('mksession') &&
            \ has('statusline') &&
            \ has('nvim')

        autocmd BufEnter * lua require'wincent.autocmds'.buf_enter()
        autocmd BufLeave ?* lua require'wincent.autocmds'.buf_leave()
        autocmd BufWinEnter ?* lua require'wincent.autocmds'.buf_win_enter()
        autocmd BufWritePost ?* lua require'wincent.autocmds'.buf_write_post()
        autocmd FocusGained * lua require'wincent.autocmds'.focus_gained()
        autocmd FocusLost * lua require'wincent.autocmds'.focus_lost()
        autocmd InsertEnter * lua require'wincent.autocmds'.insert_enter()
        autocmd InsertLeave * lua require'wincent.autocmds'.insert_leave()
        autocmd VimEnter * lua require'wincent.autocmds'.vim_enter()
        autocmd WinEnter * lua require'wincent.autocmds'.win_enter()
        autocmd WinLeave * lua require'wincent.autocmds'.win_leave()
      endif

      autocmd BufWritePost */spell/*.add silent! :mkspell! %
      autocmd BufWritePost * call wincent#autocmds#encrypt(expand('<afile>:p'))
      autocmd BufFilePost,BufNewFile,BufReadPost * call wincent#autocmds#apply_overrides()

      if exists('##TextYankPost')
        autocmd TextYankPost * silent! lua return (not vim.v.event.visual) and require'vim.highlight'.on_yank('Substitute', 200)
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
