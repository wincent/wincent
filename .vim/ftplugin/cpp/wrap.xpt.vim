if exists("b:__WRAP_CPP_XPT_VIM__")
  finish
endif

let b:__WRAP_CPP_XPT_VIM__ = 1

XPTemplateDef
XPT try_ hint=try\ {\ SEL\ }\ catch...
try
{
    `wrapped^
}
`...^catch ( `except^ )
{
    `handler^
}`...^
`catch...^catch ( ... )
{
    \`cursor\^
}^^

..XPT

