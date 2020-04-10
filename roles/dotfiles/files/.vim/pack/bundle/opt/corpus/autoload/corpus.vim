function! corpus#buf_new_file() abort
  let l:file=expand('<afile>:p')
  let l:directory=fnamemodify(l:file, ':h')
  if l:directory == corpus#directory()
    call append(0, [
          \   '---',
          \   'title: ' . corpus#title_for_file(l:file),
          \   '---',
          \   ''
          \ ])
  endif
endfunction

function! corpus#buf_write_post() abort
  let l:file=expand('<afile>')
  call corpus#commit(l:file)
endfunction

function! corpus#buf_write_pre() abort
  let l:file=expand('<afile>')
  call corpus#update_references()
  call corpus#update_title(l:file)
endfunction

function! corpus#commit(file) abort
  " TODO
  unsilent echomsg 'git commit ' . a:file
endfunction

function! corpus#directory() abort
  let l:directory=fnamemodify(get(g:, 'CorpusDirectory', '~/Documents/Corpus'), ':p')
  let l:len=len(l:directory)
  if l:directory[l:len - 1] == '/'
    return strpart(l:directory, 0, l:len - 1)
  else
    return l:directory
  endif
endfunction

" Adds 'corpus' to the 'filetype' if the current file is under
" `corpus#directory()`.
function! corpus#ftdetect() abort
  let l:file=expand('<afile>:p')
  let l:directory=fnamemodify(l:file, ':h')
  if l:directory == corpus#directory()
    set filetype+=.corpus
  endif
endfunction

function! corpus#title_for_file(file) abort
  return fnamemodify(a:file, ':t:r')
endfunction

function! corpus#update_references() abort
  " TODO
  unsilent echomsg 'update refs'
endfunction

function! corpus#update_title(file) abort
  " TODO
  unsilent echomsg 'update title ' . a:file

  " get metadata
  " if title there, check it -- update if necessary
  " if missing add it
  " if no metadata, add it
  if getline(1) == '---'
  endif
endfunction

finish

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
      " call corpus#open_loclist()
      call corpus#open_qflist()

      let l:terms=l:match[1]
      if len(l:terms)
        " Weight title matches higher
        " TODO: weight left-most matches higher
        let l:results=corpus#search_titles(l:terms)
        call extend(l:results, corpus#search_content(l:terms))
        if len(l:results)
          call corpus#preview(l:results[0])

          " Update location list.
          let l:list=map(l:results, {i, val -> {
                \   'filename': val,
                \   'lnum': 1
                \ }})
          " call setloclist(0, l:list, 'r', {'title': 'Corpus'})
          call setqflist([], 'r', {'items': l:list, 'title': 'Corpus'})
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

function! corpus#exists(basename) abort
  return filereadable(corpus#file(a:basename))
endfunction

" Get the full path to a file in the Corpus directory.
function! corpus#file(basename) abort
  return corpus#join(corpus#directory(), a:basename)
endfunction

" Join multiple path components using a separator (/).
function! corpus#join(...) abort
  return join(a:000, '/')
endfunction

" Returns 1 if all needles are present in haystack.
function! corpus#match(haystack, needles) abort
  let l:haystack_len=len(a:haystack)
  for l:needle in a:needles
    let l:index=stridx(a:haystack, l:needle)
    if l:index==-1
      " Needle wasn't found.
      return 0
    else
      if l:index + len(l:needle) == l:haystack_len
        " Needle was found, but only if we include the extension in the
        " haystack, and we don't want to do that.
        return 0
      endif
    endif
  endfor

  " No needles were missing: success.
  " Note that this means that an empty search always matches.
  return 1
endfunction

function! corpus#open_loclist() abort
  let l:wininfo=getwininfo()
  let l:loclists=filter(getwininfo(), 'v:val.loclist')
  if !len(l:loclists)
    try
      lopen
    catch /./
      " Could happen if preview window has focus, for example.
    endtry
  endif
endfunction

function! corpus#open_qflist() abort
  let l:wininfo=getwininfo()
  let l:qflist=filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
  if !len(l:qflist)
    call setqflist([], 'r', {'title': 'Corpus'})
    copen
  endif
endfunction

function! corpus#preview(basename) abort
  let l:file=corpus#file(a:basename)
  execute 'pedit ' . fnameescape(l:file)
  redraw
endfunction

function! corpus#run(args) abort
  let l:args=copy(a:args)
  call map(l:args, {i, word -> shellescape(word)})
  let l:command=join(l:args, ' ')
  return systemlist(l:command)
endfunction

" This isn't ideal, but we do content searches with Git and title searches
" internally, which means that if you search for "foo bar" and we have a
" document called "foo.md" with contents "bar", we won't find it.
"
" In order to provide unified search, we'd need to do all searching internally,
" or all searching externally via a custom process.
function! corpus#search_content(terms) abort
  let l:command=[
        \   'git',
        \   '-C',
        \   corpus#directory(),
        \   'grep',
        \   '-I',
        \   '-F',
        \   '-l',
        \   '-z',
        \   '--all-match',
        \   '--full-name',
        \   '--untracked',
        \ ]

  if !corpus#smartcase(a:terms)
    call add(l:command, '-i')
  endif

  for l:term in split(a:terms)
    call extend(l:command, ['-e', l:term])
  endfor
  call extend(l:command, ['--', '*.md'])
  let l:files=corpus#run(l:command)
  if len(l:files) == 1
    " We expect one lone line from `git grep`, and Vim will have turned
    " NUL bytes inside that line into newlines, so we split again.
    return split(l:files[0], '\n')
  else
    return []
  endif
endfunction

function! corpus#search_titles(terms) abort
  let l:smartcase=corpus#smartcase(a:terms)
  let l:terms=split(a:terms)

  if !l:smartcase
    map(l:terms, {i, val -> tolower(val)})
  endif

  return filter(copy(s:notes), {i, val -> corpus#match(l:smartcase ? val : tolower(val), l:terms)})
endfunction

" Like 'smartcase', will be case-insensitive unless argument contains an
" uppercase letter.
function! corpus#smartcase(terms) abort
  return match(a:terms, '\v[A-Z]') == -1
endfunction
