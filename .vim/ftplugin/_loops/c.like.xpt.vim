if exists("b:___LOOPS_C_LIKE_XPT_VIM__")
  finish
endif
let b:___LOOPS_C_LIKE_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : '/* void */;'}, 'keep')

" inclusion

XPTinclude
      \ _loops/c.for.like


call XPTemplatePriority('like')
" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
XPTemplateDef

XPT while0 hint=do\ {\ ..\ }\ while\ ($FALSE)
do `$BRACKETSTYLE^{
  `cursor^
} `$BRACKETSTYLE^while (`$FALSE^)


XPT do hint=do\ {\ ..\ }\ while\ (..)
do `$BRACKETSTYLE^{
  `cursor^
} `$BRACKETSTYLE^while (`condition^)


XPT while1 hint=while\ ($TRUE)\ {\ ..\ }
while (`$TRUE^) `$BRACKETSTYLE^{
  `cursor^
}


