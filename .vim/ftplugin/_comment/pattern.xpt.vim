if exists("b:___COMMENT_PATTERN_XPT_VIM__")
  finish
endif
let b:___COMMENT_PATTERN_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition

" inclusion

call XPTemplatePriority('like')
" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================

if has_key(s:v, '$CL') && has_key(s:v, '$CR')

  call XPTemplate('cc', {'hint' : '$CL $CR'}, [ '`$CL^ `cursor^ `$CR^' ])
  call XPTemplate('cc_', {'hint' : '$CL ... $CR'}, [ '`$CL^ `wrapped^ `$CR^' ])

  " block comment
  call XPTemplate('cb', {'hint' : '$CL ...'}, [
        \'`$CL^', 
        \' `$CM^ `cursor^', 
        \' `$CR^' ])

  " block doc comment
  call XPTemplate('cd', {'hint' : '$CL$CM ...'}, [
        \'`$CL^`$CM^', 
        \' `$CM^ `cursor^', 
        \' `$CR^' ])

endif

if has_key(s:v, '$CS')

  " line comment
  call XPTemplate('cl', {'hint' : '$CS'}, [ '`$CS^ `cursor^' ])

endif


