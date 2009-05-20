if !exists("g:__XPTEMPLATE_VIM__")
  finish
endif

if exists("g:__XPT_PLUGIN_PROTECT_VIM__")
  finish
endif
let g:__XPT_PLUGIN_PROTECT_VIM__ = 1


fun! s:XPTprotect(x) "{{{
  let x = a:x
  let ctx = x.curctx


  if !g:xptemplate_limit_curosr
    return 1
  endif

  let curpos = getpos(".")[1:2]

  let ctl = g:XPT.CTL(x)
  let cbr = g:XPT.CBR(x)

  let lt = getline(ctl[0])
  let lb = getline(cbr[0])

  let lastLine = ctx.lastBefore . ctx.lastAfter


  " " TODO more precise check
  " if curpos[0] < ctl[0]
  " endif


  if curpos[0] == ctl[0] && curpos[0] == cbr[0] && len(lt) < len(lastLine) 
      " call Log("less than original line!!!!!!!!!!!!!!!!!!!!!")

      normal! 0d$
      let @0 = lastLine
      normal! "0P

      let curpos = [curpos[0], len(ctx.lastBefore) + 1]

  else
    let lastBefore0 = ctl[1] > 1 ? lt[:ctl[1]-2] : ""

    if lastBefore0 != ctx.lastBefore && curpos[1] < ctl[1] && curpos[0] == ctl[0]
      " call Log("left changed!!!!!!!!!!!!!!!!!!!!!")
      " call Log("last left:".ctx.lastBefore)
      " call Log("curr left:".lastBefore0)
      normal! d0
      let @0 = ctx.lastBefore
      normal! "0P
    endif


    let lastAfter0 = lb[cbr[1]-1:]

    if lastAfter0 != ctx.lastAfter && curpos[1] > cbr[1] && curpos[0] == cbr[0]
      " call Log("right changed!!!!!!!!!!!!!!!!!!!!!")
      " call Log("cur   =".lastAfter0)
      " call Log("last  =".ctx.lastAfter)
      normal! d$
      let @0 = ctx.lastAfter
      normal! "0P
    endif

  endif

  silent! normal! zO

  call cursor(curpos)


  return 1
endfunction "}}}

fun! g:XPT.XPTprotect(x)
  return s:XPTprotect(a:x)
endfunction

" call g:XPTaddPlugin("beforeUpdate", "XPTprotect")
