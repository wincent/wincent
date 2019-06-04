function! corpus#choose(selection) abort
  if corpus#exists(a:selection)
    execute 'edit ' . fnameescape(a:selection)
  else
    " TODO: if no "md" suffix, add it
  endif

  " TODO: decide whether we want to close preview once finished selecting
  " a file (maybe?)
  pclose
endfunction

function! corpus#cmdline_changed(char) abort
  if a:char == ':'
    let l:line=getcmdline()
    let l:match=matchlist(l:line, '\v^\s*Corpus\s+(.{-})\s*$')
    if len(l:match)
      let l:file=l:match[1]
      if len(l:file)
        echomsg 'checking: "'.l:file.'"'
        if corpus#exists(l:file)
          call corpus#preview(l:file)
        endif
      endif
    endif
  endif
endfunction

let s:notes=[]

function! corpus#cmdline_enter(char) abort
  if a:char == ':'
    " TODO: only do this if we previously wrote a change to the directory
    " TODO: only do it if we're actually running :Corpus and not something else

    let l:directory=corpus#directory()
    let l:glob=corpus#join(l:directory, '*.md')
    let s:notes=glob(l:glob, 1, 1)

    " Convert absolute paths to basenames.
    call map(s:notes, {i, file -> fnamemodify(file, ':t')})

    call sort(s:notes)
  endif
endfunction

" Custom completion function.
"
" If the command line currently contains:
"
"     :Corpus abcdef
"
" and the cursor is currently at "d", on hitting <Tab>, we'll be called with:
"
" - arg_lead: "abc"
" - cmd_line: "Corpus abcdef"
" - cursor_pos: 10
"
function! corpus#complete(arg_lead, cmd_line, cursor_pos) abort
  let l:head=a:arg_lead
  let l:tail=strpart(a:cmd_line, a:cursor_pos)
  let l:matches=filter(copy(s:notes), {i, basename -> stridx(basename, l:head) == 0})
  return l:matches
endfunction

function! corpus#directory() abort
  return expand(get(g:, 'CorpusDirectory', '~/Documents/Corpus'))
endfunction

function! corpus#exists(basename) abort
  return filereadable(corpus#file(a:basename))
endfunction

function! corpus#file(basename) abort
  return corpus#join(corpus#directory(), a:basename)
endfunction

function! corpus#join(...) abort
  return join(a:000, '/')
endfunction

function! corpus#preview(basename) abort
  let l:file=corpus#file(a:basename)
  execute 'pedit ' . fnameescape(l:file)
  redraw
endfunction
