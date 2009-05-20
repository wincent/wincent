if exists("b:__VIM_VIM_XPT_VIM__")
  finish
endif
let b:__VIM_VIM_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
XPTinclude 
      \ _common/common

" ========================= Function and Varaibles =============================


" ================================= Snippets ===================================
call XPTemplate('vimformat', [ 'vim:tw=78:ts=8:sw=2:sts=2:et:norl:fdm=marker:fmr={{{,}}}' ])

XPTemplateDef

XPT once hint=if\ exists..\ finish\ ..\ let
XSET i=headerSymbol()
if exists("`g^:`i^")
  finish
endif
let `g^:`i^ = 1
`cursor^


XPT log hint=call\ log\ on\ selection
call Log(`_^)


XPT fun hint=fun!\ ..(..)\ ..\ endfunction
XSET arg..|post=ExpandIfNotEmpty(', ', 'arg..')
fun! `name^(`arg..^) "{{{
  `cursor^
endfunction "}}}


XPT method hint=fun!\ Dict.name\ ...\ endfunction
XSET arg..|post=ExpandIfNotEmpty(', ', 'arg..')
fun! `Dict^.`name^(`arg..^)
  `cursor^
endfunction


XPT while hint=while\ ..\ ..\ endwhile
while `cond^
  `cursor^
endwhile


XPT while1 hint=while\ 1\ ..\ endwhile
while 1
  `cursor^
endwhile


XPT fordic hint=for\ [..,..]\ in\ ..\ ..\ endfor
for [`k^, `v^] in items(`dic^)
  `cursor^
endfor


XPT forin hint=for\ ..\ in\ ..\ ..\ endfor
for `v^ in `list^
  `cursor^
endfor


XPT try hint=try\ ..\ catch\ ..\ finally...
try
  `^
catch /`^/
  `^
`finally...^finally
  \`cursor\^^^
endtry



XPT if hint=if\ ..\ else\ ..
XSET else...|post=\nelse\n  `cursor^
if `cond^
  `_^`
`else...^
endif


XPT str_ hint=transform\ SEL\ to\ string
string(`wrapped^)


