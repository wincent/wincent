if exists("b:___LOOPS_JAVA_LIKE_XPT_VIM__")
  finish
endif
let b:___LOOPS_JAVA_LIKE_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
" call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion

call XPTemplatePriority('like-')


" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
"
XPTemplateDef

XPT for hint=for\ i++
for (`int^ `i^ = `0^; `i^ < `len^; ++`i^) `$BRACKETSTYLE^{
    `cursor^
}

XPT forr hint=for\ i--
for (`int^ `i^ = `n^; `i^ >`=^ `end^; --`i^) `$BRACKETSTYLE^{
    `cursor^
}

