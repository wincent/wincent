" Generic mechanism for scheduling a unit of deferable work.
function! defer#defer(evalable) abort
  if has('autocmd') && has('vim_starting')
    " Note that these commands are not defined in a group, so that we can call
    " this function multiple times. We rely on autocmds#idleboot to ensure that
    " this event is only fired once.
    execute 'autocmd User WincentDefer ' . a:evalable
  else
    execute a:evalable
  endif
endfunction

" Specific function for defering a `:packadd` operation.
function! defer#packadd(pack, plugin) abort
  execute "call defer#defer('call s:packadd(\"' . a:pack . '\", \"' . a:plugin . '\")')"
endfunction

" Load a plug-in lazily the first time a mapping is used.
function! defer#lazy(pack, plugin, mapping, command, after) abort
  call s:packadd(a:pack, a:plugin)
  execute a:mapping
  execute a:command
  execute 'call ' . a:after
endfunction

function! s:packadd(pack, plugin) abort
  if has('packages')
    execute 'packadd ' . a:pack
  else
    call s:infect(a:pack, a:plugin)
  end
endfunction

function! s:infect(pack, plugin)
  if !exists('g:loaded_pathogen')
    source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim
  endif
  call pathogen#infect('pack/' . a:pack . '/opt/{}')
  execute 'runtime! plugin/' . a:plugin
endfunction
