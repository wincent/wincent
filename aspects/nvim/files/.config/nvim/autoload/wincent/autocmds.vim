function! wincent#autocmds#format(motion) abort
  let l:v=operator#user#visual_command_from_wise_name(a:motion)
  silent execute 'normal!' '`[' . l:v . '`]gq'
  '[,']retab!
endfunction
