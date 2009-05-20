if exists("b:__JAVASCRIPT_JAVASCRIPPT_XPT_VIM__")
  finish
endif
let b:__JAVASCRIPT_JAVASCRIPPT_XPT_VIM__ = 1



" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'$TRUE': 'true', '$FALSE' : 'false', '$NULL' : 'null', '$UNDEFINED' : 'undefined', '$INDENT_HELPER' : '/* */;'})

" inclusion
XPTinclude
      \ _common/common
      \ _condition/ecma
      \ _comment/c.like
      \ _condition/c.like


" ========================= Function and Variables =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT bench hint=Benchmark
XSET log=console.log
XSET job=$INDENT_HELPER
XSET jobn=$INDENT_HELPER
var t0 = new Date().getTime();
for (var i = 0; i < `times^; ++i){
  `job^
}
var t1 = new Date().getTime();
for (var i = 0; i < `times^; ++i){
  `jobn^
}
var t2 = new Date().getTime();
`log^(t1-t0, t2-t1);


XPT asoe hint=assertObjectEquals
assertObjectEquals(`mess^
                  , `arr^
                  , `expr^);


XPT cmt hint=/**\ @auth...\ */
XSET author=$author
XSET email=$email
/**
* @author : `author^ | `email^
* @description
*     `cursor^
* @return {`Object^} `desc^
*/


XPT cpr hint=@param
@param {`Object^} `name^ `desc^


XPT if hint=if\ (..)\ {..}
XSET job=$INDENT_HELPER
XSET else...|post=\nelse {\n`cursor^\n}
if (`condition^){
  `job^
}`
`else...^


" file comment
" 4 back slash represent 1 after rendering.
XPT fcmt hint=full\ doxygen\ comment
XSET author=$author
XSET email=$email
/**-------------------------/// `sum^ \\\---------------------------
 *
 * <b>`function^</b>
 * @version : `1.0^
 * @since : `date^
 * 
 * @description :
 *   `cursor^
 * @usage : 
 * 
 * @author : `author^ | `email^
 * @copyright : 
 * @TODO : 
 * 
 *--------------------------\\\ `sum^ ///---------------------------*/


XPT fun hint=function\ ..(\ ..\ )\ {..}
XSET arg..|post=ExpandIfNotEmpty(', ', 'arg..')
function` `name^ (`arg..^) {
  `cursor^
  return;
}


XPT for hint=for\ (var..;..;++)
for (var `i^ = 0; `i^ < `ar^.length; ++`i^){
  var `e^ = `ar^[`i^];
  `cursor^
}


XPT forin hint=for\ (var\ ..\ in\ ..)\ {..}
for (var `i^ in `ar^){
  var `e^ = `ar^[`i^];
  `cursor^
}

XPT kv hint=..\ = \..
`key^ = `value^;

XPT new hint=var\ ..\ =\ new\ ..\\(..)
XSET arg..|post=ExpandIfNotEmpty(', ', 'arg..')
var `^ = new `Constructor^(`arg..^)

XPT proto hint=...prototype...\ =\ function\\(..)\ {\ ..\ }
XSET arg..|post=ExpandIfNotEmpty(', ', 'arg..')
`Class^.prototype.`method^ = function(`arg..^) {
`cursor^
}

XPT setT hint=setTimeout\\(function\\()\ {\ ..\ },\ ..)
XSET job=$INDENT_HELPER
XSET milliseconds=1000
setTimeout(function() { `job^ }, `milliseconds^)

XPT this hint=this...\ = \..;
this.`var^ = `cursor^;

XPT try hint=try\ {..}\ catch\ {..}\ finally
XSET finally...|post=\nfinally {\n`cursor^\n}
XSET job=$INDENT_HELPER
try {
  `job^
}
catch (`err^) {
  `dealError^
}`...^
catch (`err^) {
  `dealError^
  }`...^`
`finally...^
