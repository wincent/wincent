if !exists("g:__XPTEMPLATE_VIM__")
  finish
endif

if exists("g:__XPT_PLUGIN_FORMATTER_VIM__")
  finish
endif
let g:__XPT_PLUGIN_FORMATTER_VIM__ = 1

fun! g:XPT.FormatLine(x)
  let x = a:x
  let ctx = x.curctx


endfunction

fun! g:XPT.FormatTemplate(x)
  let x = a:x
  let ctx = x.curctx

  let p = getpos(".")[1:2]
  let rng = g:XPT.TmplRange()
  normal! gv=
  call cursor(p)
endfunction

fun! g:XPT.FormatItem(x)
endfunction



" call g:XPTaddPlugin("afterRender", "FormatTemplate")
" call g:XPTaddPlugin("afterFinish", "FormatTemplate")
" call g:XPTaddPlugin("afterUpdate", "FormatLine"
