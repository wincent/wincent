" When opening a new file in a Corpus-managed location, pre-populate it
" with metadata of the form:
"
"   ---
"   title: Title based on file name
"   tags: wiki
"   ---
"
" or:
"
"   ---
"   title: Title based on file name
"   ---
"
function! corpus#buf_new_file() abort
  let l:file=corpus#normalize('<afile>')
  call corpus#update_metadata(l:file)
  let b:corpus_new_file=1
endfunction

function! corpus#buf_write_post() abort
  let l:file=corpus#normalize('<afile>')
  if has_key(b:, 'corpus_new_file')
    unlet b:corpus_new_file
    let l:operation='create'
  else
    let l:operation='update'
  endif
  call corpus#commit(l:file, l:operation)
endfunction

function! corpus#buf_write_pre() abort
  let l:file=corpus#normalize('<afile>')
  call corpus#update_references(l:file)
  call corpus#update_metadata(l:file)
endfunction

function! corpus#commit(file, operation) abort
  let l:config=corpus#config_for_file(a:file)
  if !get(l:config, 'autocommit', 0)
    return
  endif
  let l:file=fnamemodify(a:file, ':t:r')

  " Note that this will fail silently if there are no changes to file (because
  " we aren't passing `--allow-empty`) and that's ok.
  call system(
        \   'git -C ' .
        \   shellescape(l:config.location) .
        \   ' commit -m ' .
        \   shellescape('docs: ' . a:operation . ' ' . l:file . ' (Corpus autocommit)') .
        \   ' -- ' .
        \   shellescape(a:file)
        \ )
endfunction

" Returns config from `g:CorpusDirectories` for `file`, or an empty dictionary
" if `file` is not in one of the directories defined in `g:CorpusDirectories`.
function! corpus#config_for_file(file) abort
  let l:base=fnamemodify(a:file, ':h')
  let l:config=get(g:, 'CorpusDirectories', {})
  for l:directory in keys(l:config)
    let l:candidate=corpus#normalize(l:directory)
    if l:candidate == l:base
      return extend({'location': l:candidate}, l:config[l:directory])
    endif
  endfor
  return {}
endfunction

" Minimal subset of:
"
" https://spec.commonmark.org/0.29/#link-reference-definition
function! corpus#extract_link_reference_definition(line) abort
  let l:match=matchlist(a:line, '\v^ {0,3}\[(\s*\S.*)\]:\s*(.+)')
  if len(l:match)
    " TODO: validate innards
    return [l:match[1], l:match[2]]
  else
    return []
  endif
endfunction

" Loose parsing of reference links. Of the three types, we only look for
" shortcut reference links:
"
" - Full reference link [text][id]
" - Collapsed reference link [id][]
" - Shortcut reference link [id]
"
" See: https://spec.commonmark.org/0.29/#reference-link
function! corpus#extract_reference_links(line) abort
  let l:start=0
  let l:max=len(a:line)

  let l:reference_links=[]

  while l:start < l:max
    " Negative lookbehind (@<!): any [ or ` not preceded by a backslash.
    let l:index=match(a:line, '\v\\@<!(`|[)', l:start)
    if a:line[l:index] == '['
      " May be a link.
      let l:end=match(a:line, '\v\\@<!]', l:index)

      if l:end == -1
        " No end marker found; we're done.
        break
      else
        let l:id = strpart(a:line, l:index + 1, l:end - l:index - 2)
        " Exclude stuff that we know can't be in a file name.
        " eg. [this ~is~ *obviously* `not` a file name]
        if match(l:id, '\v^[ A-Za-z0-9-]+$') == 0
          " Look ahead to be sure this isn't a normal link.
          let l:next=a:line[l:end + 1]
          if l:next != '[' && l:next != '('
            call add(l:reference_links, strpart(a:line, l:index + 1, l:end - l:index - 1))
          endif
        endif

        " (Hopefully rare) gotcha here, if we skip over a normal link
        " that contains something like "[foo]" in its link target we
        " will get a false positive.
        let l:start=l:end + 1
      endif
    elseif a:line[l:index] == '`'
      " May be a code span: https://spec.commonmark.org/0.29/#code-spans
      let l:backticks=matchstr(a:line, '\v`+', l:index)

      " Again, negative lookbehind to find matching run of backticks not preceded
      " by a slash.
      let l:end=match(a:line, '\v\\@<!`{' . len(l:backticks) . '}', l:index)

      if l:end == -1
        " No end marker found; not a code span.
        let l:start=l:index + len(l:backticks)
      else
        " Skip past end marker.
        let l:start=l:end + len(l:backticks)
      endif
    else
      " No unescaped [ or ` found.
      break
    endif
  endwhile

  return l:reference_links
endfunction

" Adds 'corpus' to the 'filetype' if the current file is under a
" directory configured via `g:CorpusDirectories`.
function! corpus#ftdetect() abort
  let l:file=corpus#normalize('<afile>')
  let l:config=corpus#config_for_file(l:file)
  if len(l:config)
    set filetype+=.corpus
  endif
endfunction

let s:metadata_key_value_pattern='\v^\s*(\w+)\s*:\s*(\S.{-})\s*$'

" Returns raw metadata as a list of strings; eg:
"
"   ['tags: wiki', 'title: foo']
"
" If there is no valid metadata, an empty list is returned.
"
" If there are blank lines in the metadata, they are included in the list.
function! corpus#get_metadata_raw() abort
  if match(getline(1), '\v^---\s*$') != -1
    let l:metadata=[]
    for l:i in range(2, line('$'))
      let l:line=getline(l:i)
      if match(l:line, '\v^\s*$') != -1
        call add(l:metadata, '')
        continue
      elseif match(l:line, '\v^---\s*$') != -1
        return l:metadata
      endif
      let l:match=matchlist(l:line, s:metadata_key_value_pattern)
      if len(l:match) == 0
        return []
      endif
      call add(l:metadata, (l:match[0]))
    endfor
  endif
  return []
endfunction

" Returns metadata as a dictionary; eg:
"
"   {'tags': 'wiki', 'title': 'foo'}
"
" If there is no valid metadata, an empty dictionary is returned.
function! corpus#get_metadata() abort
  let l:raw=corpus#get_metadata_raw()
  if len(l:raw)
    let l:metadata={}
    for l:line in l:raw
      let l:match=matchlist(l:line, s:metadata_key_value_pattern)
      if len(l:match)
        let l:metadata[l:match[1]]=l:match[2]
      endif
    endfor
    return l:metadata
  else
    return {}
  endif
endfunction

" Turns `file` into a simplified absolute path with all symlinks resolved. If
" `file` corresponds to a directory any trailing slash will be removed.
function! corpus#normalize(file) abort
  let l:file=fnamemodify(resolve(expand(a:file)), ':p')
  let l:len=len(l:file)
  if l:file[l:len - 1] == '/'
    return strpart(l:file, 0, l:len - 1)
  else
    return l:file
  endif
endfunction

function! corpus#set_metadata(metadata) abort
  " Remove old metadata, if present.
  let l:raw=corpus#get_metadata_raw()
  if (len(l:raw))
    " +2 lines for the '---' delimiters.
    call deletebufline('.', 1, len(l:raw) + 2)
  endif

  " Format new metadata.
  let l:lines=['---']
  let l:keys=keys(a:metadata)
  for l:key in l:keys
    call add(l:lines, l:key . ': ' . a:metadata[l:key])
  endfor
  call add(l:lines, '---')

  " Prepend new metadata.
  call append(0, l:lines)

  " Make sure there is at least one blank line after metadata.
  " +2 lines for the '---' delimiters.
  " +1 more to see next line.
  let l:next=len(l:keys) + 2 + 1
  if match(getline(l:next), '\v^\s*$') == -1
    call append(l:next - 1, '')
  endif
endfunction

function! corpus#test() abort
  let v:errors=[]

  " Find all the functions in corpus/test.vim and call them.
  for l:candidate in split(&rtp, ',')
    let l:source=join([l:candidate, 'autoload', 'corpus', 'test.vim'], '/')
    if filereadable(l:source)
      let l:lines=readfile(l:source)
      for l:line in l:lines
        let l:match=matchlist(l:line, '\v^function! (corpus#test#[a-z_]+)\(\)')
        if len(l:match)
          execute 'call ' . match[1] . '()'
        endif
      endfor
      break
    endif
  endfor

  if len(v:errors)
    echoerr 'Errors: ' . len(v:errors) . '; please see v:errors'
  endif
endfunction

function! corpus#title_for_file(file) abort
  return fnamemodify(a:file, ':t:r')
endfunction

function! corpus#update_references(file) abort
  let l:config=corpus#config_for_file(a:file)
  if !get(l:config, 'autoreference', 0)
    return
  endif

  " Skip over metadata.
  let l:raw=corpus#get_metadata_raw()
  if len(l:raw)
    let l:start=len(l:raw) + 2 + 1
  else
    let l:start=1
  endif

  " Look for link reference definitions and reference links.
  let l:labels={}
  let l:references={}

  " We don't look for link reference definitions or reference links
  " inside of fenced code blocks.
  "
  " https://spec.commonmark.org/0.29/#fenced-code-blocks
  let l:fence=v:null

  for l:i in range(l:start, line('$'))
    let l:line=getline(l:i)

    if l:fence == v:null
      " Line starting with 3 (or more) backticks or 3 (or more) tildes.
      let l:match=matchlist(l:line, '\v^ {0,3}(`{3,}|~{3,})[^`]+$')
      if len(l:match)
        let l:fence='\v^ {0,3}' . l:match[1][0] . '{' . len(l:match[1]) . ',}\s*$'
        continue
      endif
    else
      if match(l:line, l:fence) != -1
        let l:fence=v:null
      endif
      continue
    endif

    " Indented code block.
    " https://spec.commonmark.org/0.29/#indented-code-block
    if match(l:line, '\v^ {4}') != -1
      continue
    endif

    let l:match=corpus#extract_link_reference_definition(l:line)
    if len(l:match)
      let l:labels[l:match[0]]=l:match[1]
      continue
    endif

    for l:reference in corpus#extract_reference_links(l:line)
      let l:references[l:reference]=1
    endfor
  endfor

  " If there are existing labels, we assume they are at the bottom.
  let l:has_labels=!!len(l:labels)

  for l:reference in sort(keys(l:references))
    if !has_key(l:labels, l:reference)
      " Have to add l:reference
      if !l:has_labels
        " Add a blank separator line if there is not one there already.
        let l:has_labels=1
        if match(getline(line('$')), '\v^\s*$') == -1
          call append(line('$'), '')
        endif
      endif

      let l:base=get(l:config, 'base', '')
      let l:transform=get(l:config, 'transform', 'local')
      if l:transform == 'local'
        let l:target='<' . l:base . l:reference . '>'
      elseif l:transform == 'web'
        let l:target=substitute(l:base . l:reference, ' ', '_', 'g')
      else
        let l:target=l:base . l:reference
      endif
      call append(line('$'), '[' . l:reference . ']: ' . l:target)
    endif
  endfor
endfunction

function! corpus#update_metadata(file) abort
  let l:config=corpus#config_for_file(a:file)
  if !get(l:config, 'autotitle', 0) && !has_key(l:config, 'tags')
    return
  endif

  let l:metadata=corpus#get_metadata()

  if get(l:config, 'autotitle', 0)
    let l:title=corpus#title_for_file(a:file)
    let l:metadata.title=l:title
  endif

  if has_key(l:config, 'tags')
    let l:tags=split(get(l:metadata, 'tags', ''))
    for l:tag in l:config.tags
      if index(l:tags, l:tag) == -1
        call add(l:tags, l:tag)
      endif
    endfor
    let l:metadata.tags=join(l:tags)
  endif
  call corpus#set_metadata(l:metadata)
endfunction

" =============================================================================
" =============================================================================
" =============================================================================

finish

function! corpus#directory() abort
  " TODO: support multiple directories (eg. masochist wiki subdir, corpus)
  let l:directory=fnamemodify(get(g:, 'CorpusDirectory', '~/Documents/Corpus'), ':p')
  let l:len=len(l:directory)
  if l:directory[l:len - 1] == '/'
    return strpart(l:directory, 0, l:len - 1)
  else
    return l:directory
  endif
endfunction

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