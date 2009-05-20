if exists("b:__LEX_XPT_VIM__") 
    finish 
endif
let b:__LEX_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" constant definition
"call extend(s:v, {'\\$TRUE': '1 '\\$FALSE' : '0', '\\$NULL' : 'NULL', '\\$UNDEFINED' : ''})", 

" inclusion
XPTinclude
    \ _common/common
    \ c/c

XPTemplateDef
XPT lex hint=Basic\ lex\ file
%{
/* includes */
%}
/* options */
%%
/* rules */
%%
/* C code */


XPT ruleList hint=..\ \ {..}\ ...
`reg^           { `return^ }`...^
`reg^           { `return^ }`...^


XPT rule_ hint=SEL\ \ {\ ...\ }
`wrapped^       { `cursor^ }

