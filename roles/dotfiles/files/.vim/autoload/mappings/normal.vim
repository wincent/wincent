let s:registers={}
let s:last_register=0

" Function called whenever we stop and start recording a macro.
function! mappings#normal#spy_on_registers() abort
  " Spy on named registers.
  let l:named_registers=split('abcdefghijklmnopqrstuvwxyz', '\zs')
  let l:last_register=0
  for l:register in l:named_registers
    let l:contents=getreg(l:register, 1) " , 1)
    if has_key(s:registers, l:register)
      if s:registers[l:register] != l:contents
        if !l:last_register
          let s:last_register=l:register
          let l:last_register=1
        endif
      endif
    endif
    let s:registers[l:register] = l:contents
  endfor
  return 'q'
endfunction

function! mappings#normal#repeat_last_macro() abort
  call mappings#normal#spy_on_registers()
  if s:last_register != ''
    execute 'normal @' . s:last_register
  else
    " Last resort.
    normal @q
  endif
endfunction
