if exists("b:__PREPROCESSOR_C_LIKE_XPT_VIM__") 
    finish 
endif
let b:__PREPROCESSOR_C_LIKE_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" inclusion

XPTemplateDef

XPT inc		hint=include\ <>
include <`^.h>


XPT ind		hint=include\ ""
XSET me=fileRoot()
include "`me^.h"


" TODO use comment variable instead
XPT once	hint=#ifndef\ ..\ #define\ ..
XSET symbol=headerSymbol()
#ifndef `symbol^
#define `symbol^
`cursor^
#endif /* `symbol^ */


XPT ifndef	hint=#ifndef\ ..
XSET symbol=S(fileRoot(),'\.','_','g')
XSET symbol|post=SV('.','\u&')
ifndef `symbol^ 
#    define `symbol^ 

`cursor^ 
#endif /* `symbol^ */


