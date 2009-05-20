if !exists("g:__XPTEMPLATE_VIM__")
  finish
endif

if exists("g:__XPT_PLUGIN_HIGHLIGHT_VIM__")
  finish
endif
let g:__XPT_PLUGIN_HIGHLIGHT_VIM__ = 1

if !g:xptemplate_hl 
  finish
endif


fun! g:XPT.XPTupdateHigh(x) "{{{
  if !g:xptemplate_highlight
    return 1
  endif

  let x = a:x
  let ctx = x.curctx

  if !ctx.processing
    return 1
  endif

  let pp = getpos(".")[1:2]

  let m = [g:XPT.CTL(x), g:XPT.CBR(x)]

  let cont = g:XPT.GetContentBetween(m[0], m[1])
  let l = len(cont)

  let r = g:XPT.GetStaticRange(m[0], m[1])

  let last = m[1]
  for v in ctx.inplist


    let p = g:XPT.RelToAbs(last, v)

    let r = r . '\|' . '\%'.p[0].'l\%'.p[1].'c\_.\{'.l.'}'

    call cursor(p)

    if l != 0
      let ptn = '\V'.substitute(escape(cont, '\'), "\n", '\\n', 'g').'\zs'
      let last = searchpos(ptn, 'c')
    else
      let last = p
    endif

  endfor



  exe 'match XPTCurrentItem  /'. r . '/'

  call cursor(pp)

  return 1
endfunction "}}}

call g:XPTaddPlugin("afterUpdate", "XPTupdateHigh")
call g:XPTaddPlugin("afterInitItem", "XPTupdateHigh")
