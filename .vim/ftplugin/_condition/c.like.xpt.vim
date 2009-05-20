if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : '/* void */;'}, 'keep')


call XPTemplatePriority('like')

" ================================= Snippets ===================================
XPTemplateDef

XPT if		hint=if\ (..)\ {..}\ else...
XSET job=$INDENT_HELPER
if (`condi^) `$BRACKETSTYLE^{ 
  `job^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifn		hint=if\ ($NULL\ ==\ ..)\ {..}\ else...
XSET job=$INDENT_HELPER
if (`$NULL^ == `var^) `$BRACKETSTYLE^{ 
  `job^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifnn	hint=if\ ($NULL\ !=\ ..)\ {..}\ else...
XSET job=$INDENT_HELPER
if (`$NULL^ != `var^) `$BRACKETSTYLE^{ 
  `job^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT if0		hint=if\ (0\ ==\ ..)\ {..}\ else...
XSET job=$INDENT_HELPER
if (0 == `var^) `$BRACKETSTYLE^{ 
  `job^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifn0	hint=if\ (0\ !=\ ..)\ {..}\ else...
XSET job=$INDENT_HELPER
if (0 != `var^) `$BRACKETSTYLE^{ 
  `job^
}` 
`else...`^\`$BRACKETSTYLE\^ else \`$BRACKETSTYLE\^{ 
  \`cursor\^ 
}^^


XPT ifee	hint=if\ (..)\ {..}\ elseif...
XSET job=$INDENT_HELPER
if (`condition^) `$BRACKETSTYLE^{
  `job^
}`
`...^ `$BRACKETSTYLE^else if (`cond^R("condition")^) `$BRACKETSTYLE^{ 
  `job^
}`
`...^


XPT switch	hint=switch\ (..)\ {case..}
XSET job=$INDENT_HELPER
switch (`var^) `$BRACKETSTYLE^{
  case `_^ :
    `job^
    break;
  `...^
  case `_^ :
    `job^
    break;
  `...^ 

  `default...^default:
    \`cursor\^^^
}

