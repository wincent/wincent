if exists("b:___COMMON_COMMON_XPT_VIM__")
  finish
endif
let b:___COMMON_COMMON_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()


call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$UNDEFINED' : 'undefined'}, "keep")
call extend(s:v, {'$CL': '/*', '$CM' : '*', '$CR' : '*/', '$CS' : '//'}, "keep")


call extend(s:v, {'$author' : '$author is not set, you need set g:xptemplate_vars="$author=your_name"',
      \'$email' : '$email is not set, you need set g:xptemplate_vars="$author=your_email@com"'}, 'keep')


call XPTemplatePriority("all")

" ========================= Function and Varaibles =============================
" current name
fun! s:f.N() "{{{
  if has_key(self._ctx, 'name')
    return self._ctx.name
  else
    return ""
  endif
endfunction "}}}

" name with edge
fun! s:f.NN() "{{{
  if has_key(self._ctx, 'fullname')
    return self._ctx.fullname
  else
    return ""
  endif
endfunction "}}}

" current value
fun! s:f.V() "{{{
  if has_key(self._ctx, 'value')
    return self._ctx.value
  else
    return ""
  endif
endfunction "}}}

" equals to expand()
fun! s:f.E(s) "{{{
  return expand(a:s)
endfunction "}}}

" return the context
fun! s:f.C() "{{{
  return self._ctx
endfunction "}}}

" post filter	substitute
fun! s:f.S(str, ptn, rep, ...) "{{{
  let flg = a:0 >= 1 ? a:1 : 'g'
  return substitute(a:str, a:ptn, a:rep, flg)
endfunction "}}}

" equals to S(C().value, ...)
fun! s:f.SV(ptn, rep, ...) "{{{
  let flg = a:0 >= 1 ? a:1 : 'g'
  return substitute(self.V(), a:ptn, a:rep, flg)
endfunction "}}}

" reference to another finished item value
fun! s:f.R(name) "{{{
  let ctx = self._ctx
  if has_key(ctx.namedStep, a:name)
    return ctx.namedStep[a:name]
  endif

  return ""
endfunction "}}}

" black hole
fun! s:f.VOID(...) "{{{
  return ""
endfunction "}}}

" trigger nested template
fun! s:f.Trigger(name) "{{{
  return {'action' : 'expandTmpl', 'tmplName' : a:name}
endfunction "}}}

" This function is intented to be used for popup selection :
" XSET bidule=Choose([' ','dabadi','dabada'])
fun! s:f.Choose( lst ) "{{{
    return a:lst
endfunction "}}}

fun! s:f.headerSymbol(...) "{{{
  let h = expand('%:t')
  let h = substitute(h, '\.', '_', 'g') " replace . with _
  let h = substitute(h, '.', '\U\0', 'g') " make all characters upper case

  return '__'.h.'__'
endfunction
 "}}}
 "
fun! s:f.date(...) "{{{
  return strftime("%Y %b %d")
endfunction "}}}
fun! s:f.datetime(...) "{{{
  return strftime("%c")
endfunction "}}}
fun! s:f.time(...) "{{{
  return strftime("%H:%M:%S")
endfunction "}}}
fun! s:f.file(...) "{{{
  return expand("%:t")
endfunction "}}}
fun! s:f.fileRoot(...) "{{{
  return expand("%:t:r")
endfunction "}}}
fun! s:f.fileExt(...) "{{{
  return expand("%:t:e")
endfunction "}}}
fun! s:f.path(...) "{{{
  return expand("%:p")
endfunction "}}}


" draft increment implementation
fun! s:f.CntD() "{{{
  let ctx = self._ctx
  if !has_key(ctx, '__counter')
    let ctx.__counter = {}
  endif
  return ctx.__counter
endfunction "}}}
fun! s:f.CntStart(name, ...) "{{{
  let d = self.CntD()
  let i = a:0 >= 1 ? 0 + a:1 : 0
  let d[a:name] = 0 + i
  return ""
endfunction "}}}
fun! s:f.Cnt(name) "{{{
  let d = self.CntD()
  return d[a:name]
endfunction "}}}
fun! s:f.CntIncr(name, ...)"{{{
  let i = a:0 >= 1 ? 0 + a:1 : 1
  let d = self.CntD()

  let d[a:name] += i
  return d[a:name]
endfunction"}}}



" {{{ Quick Repetition
" If something typed, <tab>ing to next generate another item other than the
" typed.
"
" If nothing typed but only <tab> to next, clear it.
"
" Normal clear typed, also clear it
" }}}
fun! s:f.ExpandIfNotEmpty(sep, item) "{{{
  let v = self.V()

  let marks = XPTmark()
  
  let t = ( v == '' || v == a:item || v == ( a:sep . a:item ) )
        \ ? ''
        \ : ( v . marks[0] . a:sep . marks[0] . a:item . marks[1] )

  return t
endfunction "}}}

" ================================= Snippets ===================================
call XPTemplateMark('`', '^')

" Shortcuts
call XPTemplate('Author', '`$author^')
call XPTemplate('Email', '`$email^')
call XPTemplate("Date", "`date()^")
call XPTemplate("File", "`file()^")
call XPTemplate("Path", "`path()^")


