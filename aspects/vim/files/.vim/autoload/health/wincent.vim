function! s:require(condition, message)
  if a:condition
    call health#report_ok(a:message)
  else
    call health#report_error(a:message)
  endif
endfunction

function! s:commandt()
  if exists(':CommandTLoad') == 2
    CommandTLoad
  else
    return 0
  endif
  if has('ruby')
    ruby
          \ ::VIM::command
          \ "return #{$command_t && $command_t.class.respond_to?(:guard) ? 1 : 0}"
  else
    return 0
  endif
endfunction

function! health#wincent#check() abort
  call health#report_start('Wincent')
  call s:require(has('ruby'), 'Has Ruby support')
  call s:require(s:commandt(), 'Has working Command-T')
endfunction
