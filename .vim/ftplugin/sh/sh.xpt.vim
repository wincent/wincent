if exists("b:__SH_XPT_VIM__")
  finish
endif
let b:__SH_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
" in shell script '`' is used very widely 
call XPTemplateMark('~', '^')

call XPTemplate('sh', "#!/bin/sh\n")
call XPTemplate('ba', "#!/bin/bash\n")
call XPTemplate('echodate', 'echo `date +~fmt^`')

call XPTemplate('forin', [
      \"for ~i^ in ~list^;do", 
      \"  ~cursor^", 
      \"done"
      \])

call XPTemplate('for', [
      \"for ((~i^ = 0; ~i^ < ~len^; ~i^++));do", 
      \"  ~cursor^", 
      \"done"
      \])

call XPTemplate('forr', [
      \'for ((~i^ = ~n^; ~i^ >~=^ ~start^; ~i^~--^));do', 
      \"  ~cursor^", 
      \"done"
      \])

call XPTemplate('while1', [
      \'while [ 1 ];do', 
      \'  ~cursor^', 
      \'done'
      \])

call XPTemplate('case', [
      \'case $~i^ in', 
      \'  ~c^)', 
      \'  ~cursor^', 
      \'  ;;', 
      \'', 
      \'  *)', 
      \'  ;;', 
      \'esac'
      \])
