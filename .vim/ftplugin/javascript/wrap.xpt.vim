if exists("b:__JAVASCRIPT_WRAP_XPT_VIM__")
  finish
endif
let b:__JAVASCRIPT_WRAP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" ========================= Function and Variables =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT bench hint=Benchmark
XSET log=console.log
var t0 = new Date().getTime();
for (var i = 0; i < `times^; ++i){
  `wrapped^
}
var t1 = new Date().getTime();
`log^(t1-t0);


XPT fun hint=function\ ..(\ ..\ )\ {..}
function` `name^ (`param^) {
  `wrapped^
  return;
}


XPT try hint=try\ {..}\ catch\ {..}\ finally
XSET finally...|post=\nfinally {\n`cursor^\n}
try {
  `wrapped^
}
catch (`err^) {
  `dealError^
}`...^
catch (`err^) {
  `dealError^
  }`...^`
`finally...^

