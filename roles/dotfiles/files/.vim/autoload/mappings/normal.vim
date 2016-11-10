function mappings#normal#repeatlastmacro()
  if empty(&buftype)
    try
      normal @@
    catch /E748/ " No previously used register
      normal @q
    endtry
  endif
endfunction
