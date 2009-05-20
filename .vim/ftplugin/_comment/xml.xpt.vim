if exists("b:___COMMENT_XML_XPT_VIM__")
  finish
endif
let b:___COMMENT_XML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$CL': '<!--', '$CM' : '' , '$CR' : '-->', '$CS' : ''})

" inclusion
XPTinclude
      \ _comment/pattern

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
