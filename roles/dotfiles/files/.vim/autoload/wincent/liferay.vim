function! wincent#liferay#deploy() abort
  let l:dir=expand('%:h:S')
  if l:dir == ''
    let l:dir=getcwd()
  end
  if exists(':terminal')
    autocmd TermOpen * ++once setlocal nobuflisted | execute "normal! G \<c-w>p"
    execute 'split +terminal\ cd\ ' . substitute(l:dir, ' ', '\\ ', 'g') . '\ &&\ portool\ deploy'
  else
    execute '!cd ' . l:dir . ' && portool deploy'
  endif
endfunction
