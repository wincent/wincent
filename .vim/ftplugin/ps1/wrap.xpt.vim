if exists("b:__PS1_WRAPPED_XPT_VIM__")
    finish
endif
let b:__PS1_WRAPPED_XPT_VIM__ = 1

XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef
XPT if_ hint=if\ (..)\ {\ SEL\ }\ ...
if ( `cond^ )
{
    `wrapped^
}`...^
elseif ( `cond2^ )
{
    `body^
}`...^`else...^
else
{
    \`body\^
}^^
