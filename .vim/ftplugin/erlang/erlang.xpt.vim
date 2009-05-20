if exists("b:__ERLANG_XPT_VIM__")
  finish
endif
let b:__ERLANG_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT inc hint=-include\ ..
-include( \"`cursor^^.hrl\").


XPT def hint=-define\ ..
-define( `what^, `def^ ).


XPT ifdef hint=-ifdef\ ..\-endif..
-ifdef( `what^ ).
  `thenmacro^
`else...^-else.
  \`cursor\^^^
-endif().


XPT ifndef hint=-ifndef\ ..\-endif
-ifndef( `what^ ).
  `thenmacro^
`else...^-else.
  \`cursor\^^^
-endif().


XPT record hint=-record\ ..,{..}
-record( `recordName^
       ,{ `field1^`...^
        , `fieldn^`...^
        }).


XPT if hint=if\ ..\ ->\ ..\ end
if
   `cond^ ->
       `body^`...^;
   `cond2^ ->
       `bodyn^`...^
end `cursor^


XPT case hint=case\ ..\ of\ ..\ ->\ ..\ end
case `matched^ of
   `pattern^ ->
       `body^`...^;
   `patternn^ ->
       `bodyn^`...^
end `cursor^


XPT rcv hint=receive\ ..\ ->\ ..\ end
receive
   `pattern^ ->
       `body^ `...^;
   `patternn^ ->
       `bodyn^`...^`after...^
after
    \`afterBody\^^^
end



XPT receive hint=receive\ ..\ ->\ ..\ end
receive
   `pattern^ ->
       `body^ `...^;
   `patternn^ ->
       `bodyn^`...^`after...^
after
    \`afterBody\^^^
end


XPT fun hint=fun\ ..\ ->\ ..\ end
fun (`params^) `_^^ -> `body^ `...^;
    (`paramsn^) `_^^ -> `bodyn^`...^
end `cursor^


XPT try hint=try\ ..\ catch\ ..\ end
try `what^
catch
    `excep^ -> `toRet^ `...^;
    `except^ -> `toRet^`...^
`after...^after
    \`afterBody\^^^
end `cursor^


XPT tryof hint=try\ ..\ of\ ..
try `what^ of
   `pattern^ ->
       `body^ `...0^;
   `patternn^ ->
       `bodyn^`...0^
catch
    `excep^ -> `toRet^ `...1^;
    `except^ -> `toRet^`...1^
`after...^after
    \`afterBody\^^^
end `cursor^


XPT function hint=f\ \(\ ..\ \)\ ->\ ..
`funName^ ( `args0^ ) `_^^ ->
    `body0^ `...^;
`name^R('funName')^ ( `argsn^ ) `_^^ ->
    `bodyn^`...^
.


