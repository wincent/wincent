if exists("b:__YACC_XPT_VIM__") 
    finish 
endif
let b:__YACC_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" constant definition

" inclusion
XPTinclude 
    \ _common/common
    \ c/c

XPTemplateDef
XPT yacc hint=Basic\ yacc\ file
%{
/* includes */
%}
/* options */
%%
/* grammar rules */
%%
/* C code */

XPT rule hint=..:\ ..\ |\ ..\ |\ ...
`ruleName^: `pattern^   { `action^ }`...^
          | `pattern^   { `action^ }`...^
          ;

XPT tok hint=%token\ ...
%token 

XPT prio hint=%left\ ...\ %right\ ...
%left   '`op^'`...0^ '`op^'`...0^`...1^
%left   '`op^'`...2^ '`op^'`...2^`...1^


