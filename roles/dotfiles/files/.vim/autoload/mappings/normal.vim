function mappings#normal#repeatlastmacro()
  try
    normal @@
  catch /E748/ " No previously used register
    normal @q
  endtry
endfunction
