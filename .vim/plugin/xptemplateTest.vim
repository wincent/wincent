if !exists("g:__XPTEMPLATE_VIM__")
  runtime plugin/xptemplate.vim
endif

if exists("g:__XPTEMPLATETEST_VIM__")
  finish
endif
let g:__XPTEMPLATETEST_VIM__ = 1

" test suite support

let s:phases = [ 1, 2, 3, 4, 5 ]
let [ s:DEFAULT, s:TYPED, s:CHAR_BEFORE, s:CHAR_AFTER, s:NESTED ] = s:phases
let s:FIRST_PHASE = s:phases[ 0 ]
let s:LAST_PHASE = s:phases[ -1 ]

com! XPTSlow redraw! | sleep 100m

fun s:XPTinsert() "{{{
  call feedkeys("i", 'mt')
endfunction "}}}
fun s:XPTtrigger(name) "{{{
  call feedkeys(a:name . "", 'mt')
endfunction "}}}
fun s:XPTtype(...) "{{{
  for v in a:000
    call feedkeys(v, 'nt')
    call feedkeys("\<tab>", 'mt')
  endfor
endfunction "}}}
fun s:XPTcancel(...) "{{{
  call feedkeys("\<cr>", 'mt')
endfunction "}}}
fun! s:LastLine() "{{{
  call feedkeys("\<C-c>G:silent a\<cr>\<cr>.\<cr>G", 'nt')
endfunction "}}}
fun s:XPTnew(name) "{{{
  call s:XPTinsert()
  call s:XPTtrigger(a:name)
endfunction "}}}
fun s:XPTwrapNew(name) "{{{
  call feedkeys("iWRAPPED_TEXT\<C-c>V", 'nt')
  if &slm =~ 'cmd'
    call feedkeys("\<C-g>", 'nt')
  endif
  call feedkeys("\<C-w>".a:name."", 'mt')

endfunction "}}}


fun! XPTtest(ft) "{{{
  augroup XPTtestGroup
    au!
    au CursorHoldI * call <SID>TestProcess('i')
    au CursorMoved * call <SID>TestProcess('n')
    au CursorMovedI * call <SID>TestProcess('i')
  augroup END

  let subft = matchstr(a:ft, '[^.]*')
  let tempPath = globpath(&rtp, 'ftplugin/_common/common.xpt.vim')
  " echom "tempPath=".tempPath
  let tempPath = split(tempPath, "\n")[0]
  " echom "tempPath=".tempPath

  let tempPath = matchstr(tempPath, '.*\ze[\\/]_common[\\/]common.xpt.vim') . '/' . subft . '/.test'

  " echom tempPath
  try
	  call mkdir(tempPath, 'p')
  catch /.*/
  endtry
  let s:tempPath = tempPath
  " echom tempPath

  exe 'e '.tempPath.'/test.page'

  set buftype=nofile
  wincmd o
  let &ft = a:ft

  let b:list = []
  let b:currentTmpl = {}
  let b:testProcessing = 0
  let b:phaseIndex = 0
  let b:testPhase = s:phases[ b:phaseIndex ]
  let b:itemNames = []

  let cmt = &cms
  let b:cmt = split(cmt, '\V%s')
  if len(b:cmt) == 0
    let b:cmt = ['', '']
  elseif len(b:cmt) == 1
    let b:cmt += ['']
  endif
  

  let tmpls = XPTgetAllTemplates()

  " remove 'Path' template
  unlet tmpls.Path

  let b:list = values(tmpls)

  " trigger test to start
  normal o


endfunction "}}}

fun s:TestFinish() "{{{
  augroup XPTtestGroup
    au!
  augroup END

  let fn = split(globpath(&rtp, 'ftplugin/'.&ft.'/test.page'), "\n")
  if len(fn) > 0
    exe "vertical diffsplit ".fn[0]

    normal! gg=G
    wincmd x
    normal! gg=G
    diffupdate
    normal! zM
  endif
  " echom "to delete:" . s:tempPath
  " echom delete(s:tempPath)

  try
    if has('win32')
      exe 'silent! !rd /s/q "'.s:tempPath.'"'
    else
      exe 'silent! !rm -rf "'.s:tempPath.'"'
    end
  catch /.*/
  endtry
endfunction "}}}

fun! s:TestProcess(mode) "{{{
  let x = g:X()
  let ctx = x.curctx


  if b:testProcessing == 0

    let b:testProcessing = 1
    let b:itemNames = []

    if len(b:list) == 0 
      call s:TestFinish()
      return
    endif


    " Each template is rendered multi times.

    let b:currentTmpl = b:list[0]
    if b:testPhase == s:LAST_PHASE
      call remove(b:list, 0)
    endif

    
    call s:LastLine()

    " if no comment string found, do not risk to draw template in comment.
    if b:testPhase == s:FIRST_PHASE && b:cmt != ['', '']
      " first time rendering the template, show original template content

      let tmpl0 = [ ' ' . '-------------' . b:currentTmpl.name . '---------------' ] 
            \+ split( b:currentTmpl.tmpl , "\n" )

      let maxLength = 0
      for line in tmpl0
        let maxLength = max( [ len(line), maxLength ] )
      endfor

      let tmpl = []
      for line in tmpl0
        if b:cmt[ 1 ] != ''
          let line = substitute( line, '\V'.b:cmt[ 1 ], '_cmt_', 'g' )
        endif
        let line = b:cmt[0] . ' ' . line . repeat( ' ', maxLength - len( line ) ) . ' ' . b:cmt[ 1 ]
        let tmpl += [ line ]
      endfor

      call feedkeys( ":silent a\n" . join( tmpl, "\n" ) . "\n\n\n\n", 'nt' )
      call s:LastLine()
    endif

    " render template
    if b:currentTmpl.wrapped
      call s:XPTwrapNew( b:currentTmpl.name )
    else
      call s:XPTnew( b:currentTmpl.name )
    endif


  else
    " b:testProcessing = 1

    " Insert mode or select mode
    " If it is in normal mode, maybe something else is going.
    if mode() =~? "[is]"
      if ctx.phase == 'fillin' 

        " XPTSlow

        " repitition, expandable or super repetition
        if ctx.name =~ '\V..'
          let b:itemNames += [ ctx.name ]

          " keep at most 5 steps
          if len( b:itemNames ) > 5 
            call remove(b:itemNames, 0)
          endif
        endif


        if len(b:itemNames) >= 3 && b:itemNames[-3] == ctx.name
          " repetition 
          call s:XPTcancel()

        elseif b:testPhase == s:DEFAULT
          " next
          call s:XPTtype('')
        elseif b:testPhase == s:TYPED
          " pseudo type
          call s:XPTtype(substitute(ctx.name, '\W', '', 'g')."_TYPED")
        else
          " not implemented yet
          call s:XPTtype('')
        endif

        " XPTSlow

      elseif ctx.phase == 'finished'
        " template finished

        let b:phaseIndex = (b:phaseIndex + 1) % len(s:phases)
        let b:testPhase = s:phases[ b:phaseIndex ]
        let b:testProcessing = 0
        call feedkeys("\<C-c>Go\<C-c>", 'nt')
      endif

    endif

  endif
endfunction "}}}


com -nargs=1 XPTtest call XPTtest(<f-args>)
