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

" TODO: decide whether this file-name searching makes any sense at all
" might just want to use Ferret (or `git grep`); i think we do...
function! corpus#cmdline_changed(char) abort
  if a:char == ':'
    let l:line=getcmdline()
    let l:match=matchlist(l:line, '\v^\s*Corpus\s+(.{-})\s*$')
    if len(l:match)

      let l:arg=l:match[1]

      if len(l:arg)
        let l:command=[
              \   'git',
              \   '-C',
              \   corpus#directory(),
              \   'grep',
              \   '-I',
              \   '-P',
              \   '-l',
              \   '-z',
              \   '--all-match',
              \   '--full-name',
              \   '--untracked',
              \ ]

        " Like 'smartcase', will be case-insensitive unless argument contains an
        " uppercase letter.
        if match(l:arg, '\v[A-Z]') == -1
          call add(l:command, '-i')
        endif

        for l:term in split(l:arg)
          call extend(l:command, ['-e', l:term])
        endfor
        call extend(l:command, ['--', '*.md'])
        let l:files=corpus#run(l:command)
        if len(l:files) == 1
          " We expect one lone line from `git grep`, and Vim will have turned
          " NUL bytes inside that line into newlines, so we split again.
          for l:file in split(l:files[0], '\n')
            call corpus#preview(l:file)
            return
          endfor
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

function! corpus#run(args) abort
  let l:args=copy(a:args)
  call map(l:args, {i, word -> shellescape(word)})
  let l:command=join(l:args, ' ')
  return systemlist(l:command)
endfunction
