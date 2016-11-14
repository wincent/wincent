let s:registers={}
let s:last_register=''
let s:is_recording=0

function! s:StoreAndCheckRegisters() abort
  " Spy on named registers only.
  let l:named_registers=split('abcdefghijklmnopqrstuvwxyz', '\zs')
  let l:last_register=0
  for l:register in l:named_registers
    let l:contents=getreg(l:register, 1, 1)
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
endfunction

" Function called whenever we stop and start recording a macro.
function! replay#spy_on_registers() abort
  let s:is_recording=!s:is_recording
  call s:StoreAndCheckRegisters()
  return 'q'
endfunction

" Function called when user presses <CR> to repeat last macro.
function! replay#repeat_last_macro() abort
  if s:is_recording
    call feedkeys("\<CR>", 'n')
    return
  endif
  call s:StoreAndCheckRegisters()
  " Don't use `normal @q` so as to avoid remapping the `q` and
  " running `replay#spy_on_registers()`.
  if s:last_register != ''
    call feedkeys('@' . s:last_register, 'n')
    let s:last_register=''
  else
    try
      normal @@
    catch /E748/ " No previously used register.
      " Last resort.
      call feedkeys('@q', 'n')
    endtry
  endif
endfunction
