" Generic mechanism for scheduling a unit of deferable work.
function! wincent#defer#defer(evalable) abort
  if has('autocmd') && has('vim_starting')
    " Note that these commands are not defined in a group, so that we can call
    " this function multiple times. We rely on autocmds#idleboot to ensure that
    " this event is only fired once.
    execute 'autocmd User WincentDefer ' . a:evalable
  else
    execute a:evalable
  endif
endfunction

" Convenience function specifically for defering a `:packadd` operation.
function! wincent#defer#packadd(pack, plugin) abort
  execute "call wincent#defer#defer('call wincent#plugin#packadd(\"' . a:pack . '\", \"' . a:plugin . '\")')"
endfunction
