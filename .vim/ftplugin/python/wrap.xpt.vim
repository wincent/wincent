if exists("b:__WRAP_PYTHON_XPT_VIM__")
  finish
endif

let b:__WRAP_PYTHON_XPT_VIM__ = 1

XPTemplateDef
XPT try_ hint=try:\ SEL\ except...
try:
    `wrapped^
except `except^:
    `handler^`...^
except `exc^:
    `handle^`...^
`else...^else:
    \`\^^^
`finally...^finally:
   \`\^^^

