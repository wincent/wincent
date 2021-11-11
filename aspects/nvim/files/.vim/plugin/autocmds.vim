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
endif
