let s:plugins={}

function! wincent#plugin#lazy(config) abort
  let l:id=a:config.pack . '::' . a:config.plugin
  let s:plugins[l:id]=a:config
  let l:load='call <SID>load("' . l:id . '")'
  if has_key(a:config, 'commands')
    for l:command in items(a:config.commands)
      let l:deletions=map(keys(a:config.commands), '"delcommand " . v:val')
      execute 'command! ' .
            \ l:command[1] . ' ' .
            \ l:command[0] . ' ' .
            \ ':' . join(l:deletions, ' <bar> ') . ' <bar> ' .
            \ l:load . ' <bar> ' .
            \ l:command[0] .
            \ ' <args>'
    endfor
  endif
  if has_key(a:config, 'nnoremap')
    for l:mapping in items(a:config.nnoremap)
      execute 'nnoremap ' .
        \ l:mapping[0] . ' ' .
        \ ':' . l:load . '<CR>' .
        \ l:mapping[1]
    endfor
  endif
endfunction

function! s:load(id) abort
  let l:config=s:plugins[a:id]
  let l:split=split(a:id, '::')
  let l:pack=l:split[0]
  let l:plugin=l:split[1]
  if has_key(l:config, 'beforeload')
    for l:item in l:config.beforeload
      execute l:item
    endfor
  endif
  call wincent#plugin#packadd(l:pack, l:plugin)
  if has_key(l:config, 'nnoremap')
    for l:mapping in items(l:config.nnoremap)
      execute 'nnoremap ' . l:mapping[0] . ' ' . l:mapping[1]
    endfor
  endif
  if has_key(l:config, 'afterload')
    for l:item in l:config.afterload
      execute l:item
    endfor
  endif
endfunction

function! wincent#plugin#packadd(pack, plugin) abort
  if has('packages')
    execute 'packadd ' . a:pack
  else
    call s:infect(a:pack, a:plugin)
  end
endfunction

function! s:infect(pack, plugin) abort
  if !exists('g:loaded_pathogen')
    source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim
  endif
  call pathogen#infect('pack/' . a:pack . '/opt/{}')
  execute 'runtime! plugin/' . a:plugin
endfunction
