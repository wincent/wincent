let s:plugins={}

function! plugin#lazy(config) abort
  let l:id=a:config.pack . '::' . a:config.plugin
  let s:plugins[l:id]=a:config
  if has_key(a:config, 'nnoremap')
    for l:mapping in items(a:config.nnoremap)
      execute 'nnoremap ' .
        \ l:mapping[0] .
        \ ' :call <SID>load("' . l:id . '")<CR>' .
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
  call plugin#packadd(l:pack, l:plugin)
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

function! plugin#packadd(pack, plugin) abort
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
