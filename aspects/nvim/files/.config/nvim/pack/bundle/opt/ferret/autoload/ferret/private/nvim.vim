" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

let s:jobs={}

function! s:info_from_job(job)
  if has_key(s:jobs, a:job)
    return s:jobs[a:job]
  endif
endfunction

let s:ripgrep_hack=0

function! s:prefinalize(output)
  if s:ripgrep_hack
    " When `rg` is passed a '.' or './' search path, it reports results as
    " './a/b/c' instead of 'a/b/c', which is super ugly in the quickfix listing,
    " so filter those out...
    return map(a:output, 'substitute(v:val, "^\\./", "", "g")')
  else
    return a:output
  endif
endfunction

function! ferret#private#nvim#search(command, ack, bang) abort
  call ferret#private#nvim#cancel()
  call ferret#private#autocmd('FerretAsyncStart')
  let s:ripgrep_hack=0
  let l:executable=split(ferret#private#executable())
  let l:default_search_paths=[]
  if l:executable[0] ==# 'rg'
    " Hack for breakage caused by rg v13.0.0; see:
    " - https://github.com/wincent/ferret/issues/78
    " - https://github.com/wincent/ferret/issues/82
    let l:expect_option_argument=0
    let l:seen_search_term=0
    let l:seen_search_path=0
    let l:search_paths_include_dot=0
    for l:arg in a:command
      if l:expect_option_argument
        let l:option=ferret#private#option(l:arg)
        if l:option == 2
          " Probably a user error.
        elseif l:option == 1
          " Probably a user error.
          let l:expect_option_argument=0
        else
          let l:expect_option_argument=0
        endif
      else
        let l:option=ferret#private#option(l:arg)
        if l:option == 2
          let l:expect_option_argument=1
        elseif l:option != 1
          if !l:seen_search_term
            let l:seen_search_term=1
          else
            let l:seen_search_path=1
            if l:arg ==# '.' || l:arg ==# './'
              let l:search_paths_include_dot=1
              break
            endif
          endif
        endif
      endif
    endfor
    if !l:seen_search_path
      let s:ripgrep_hack=1
      call extend(l:default_search_paths, ['.'])
    elseif l:search_paths_include_dot
      let s:ripgrep_hack=1
    endif
  endif
  call extend(l:executable, a:command)
  call extend(l:executable, l:default_search_paths)
  let l:job=jobstart(l:executable, {
        \   'on_stderr': 'ferret#private#nvim#err_cb',
        \   'on_stdout': 'ferret#private#nvim#out_cb',
        \   'on_exit': 'ferret#private#nvim#close_cb'
        \ })
  let s:jobs[l:job]={
        \   'job': l:job,
        \   'errors': [],
        \   'output': [],
        \   'pending_error': '',
        \   'pending_output': '',
        \   'pending_error_length': 0,
        \   'pending_output_length': 0,
        \   'result_count': 0,
        \   'ack': a:ack,
        \   'bang': a:bang,
        \   'window': win_getid()
        \ }
endfunction

" Quickfix listing will truncate longer lines than this.
let s:max_line_length=4096

function! ferret#private#nvim#err_cb(job, lines, event) dict
  let l:info=s:info_from_job(a:job)
  if type(l:info) == 4
    let l:count=len(a:lines)
    for l:i in range(l:count)
      let l:line=a:lines[l:i]
      if l:i != l:count - 1 || l:line == '' && l:info.pending_error_length
        if l:info.pending_error_length < s:max_line_length
          let l:rest=strpart(
                \   l:line,
                \   0,
                \   s:max_line_length - l:info.pending_error_length
                \ )
          call add(l:info.errors, l:info.pending_error . l:rest)
        else
          call add(l:info.errors, l:info.pending_error)
        endif
        let l:info.pending_error=''
        let l:info.pending_error_length=0
      elseif l:info.pending_error_length < s:max_line_length
        let l:info.pending_error.=l:line
        let l:info.pending_error_length+=strlen(l:line)
      endif
    endfor
  endif
endfunction

let s:limit=ferret#private#limit()

function! ferret#private#nvim#out_cb(job, lines, event) dict
  let l:info=s:info_from_job(a:job)
  if type(l:info) == 4
    if !l:info.bang && l:info.result_count > s:limit
      call s:MaxResultsExceeded(l:info)
      return
    endif
    let l:count=len(a:lines)
    for l:i in range(l:count)
      let l:line=a:lines[l:i]
      if l:i != l:count - 1 || l:line == '' && l:info.pending_output_length
        if l:info.pending_output_length < s:max_line_length
          let l:rest=strpart(
                \   l:line,
                \   0,
                \   s:max_line_length - l:info.pending_output_length
                \ )
          call add(l:info.output, l:info.pending_output . l:rest)
        else
          call add(l:info.output, l:info.pending_output)
        endif
        let l:info.pending_output=''
        let l:info.pending_output_length=0
        if !l:info.bang
          let l:info.result_count+=1
          if l:info.result_count > s:limit
            call s:MaxResultsExceeded(l:info)
            break
          endif
        endif
      elseif l:info.pending_output_length < s:max_line_length
        let l:info.pending_output.=l:line
        let l:info.pending_output_length+=strlen(l:line)
      endif
    endfor
  endif
endfunction

function! ferret#private#nvim#close_cb(job, data, event) abort dict
  " Job may have been canceled with cancel_async. Do nothing in that case.
  let l:info=s:info_from_job(a:job)
  if type(l:info) == 4
    call remove(s:jobs, a:job)
    call ferret#private#autocmd('FerretAsyncFinish')
    if !l:info.ack
      " If this is a :Lack search, try to focus appropriate window.
      call win_gotoid(l:info.window)
    endif
    call ferret#private#shared#finalize_search(s:prefinalize(l:info.output), l:info.ack)
    for l:error in l:info.errors
      unsilent echomsg l:error
    endfor
  endif
endfunction

function! ferret#private#nvim#pull() abort
  for l:job in keys(s:jobs)
    let l:info=s:jobs[l:job]
    call ferret#private#shared#finalize_search(s:prefinalize(l:info.output), l:info.ack)
  endfor
endfunction

function! ferret#private#nvim#cancel() abort
  let l:canceled=0
  for l:job in keys(s:jobs)
    call jobstop(str2nr(l:job))
    call remove(s:jobs, l:job)
    let l:canceled=1
  endfor
  if l:canceled
    call ferret#private#autocmd('FerretAsyncFinish')
  endif
endfunction

" Stop a single job as a result of hitting g:FerretMaxResults.
function! s:MaxResultsExceeded(info)
  call ferret#private#shared#finalize_search(s:prefinalize(a:info.output), a:info.ack)
  call jobstop(a:info.job)
  call remove(s:jobs, a:info.job)
  call ferret#private#autocmd('FerretAsyncFinish')
  call ferret#private#error(
        \   'Maximum result count exceeded. ' .
        \   'Either increase g:FerretMaxResults or ' .
        \   're-run the search with :Ack!, :Lack! etc.'
        \ )
endfunction

function! ferret#private#nvim#debug() abort
  return s:jobs
endfunction
