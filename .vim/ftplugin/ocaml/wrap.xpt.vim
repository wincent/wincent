if exists("b:__WRAP_OCAML_XPT_VIM__")
  finish
endif

let b:__WRAP_OCAML_XPT_VIM__ = 1

XPTemplateDef

XPT p_ hint=(SEL) 
(`wrapped^)


XPT try_ hint=try\ SEL\ with\ ..\ ->\ ..
try
    `wrapped^
with `exc^ -> `rez^`...^
   | `exc2^ -> `rez2^`...^



