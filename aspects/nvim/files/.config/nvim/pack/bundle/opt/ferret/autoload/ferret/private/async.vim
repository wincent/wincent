" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

let s:jobs={}

function! s:info_from_channel(channel)
  let l:channel_id=ch_info(a:channel)['id']
  if has_key(s:jobs, l:channel_id)
    return s:jobs[l:channel_id]
  endif
endfunction

function! ferret#private#async#search(command, ack, bang) abort
  call ferret#private#async#cancel()
  call ferret#private#autocmd('FerretAsyncStart')
  let l:command_and_args=extend(split(ferret#private#executable()), a:command)
  let l:job=job_start(l:command_and_args, {
        \   'in_io': 'null',
        \   'err_cb': 'ferret#private#async#err_cb',
        \   'out_cb': 'ferret#private#async#out_cb',
        \   'close_cb': 'ferret#private#async#close_cb',
        \   'err_mode': 'raw',
        \   'out_mode': 'raw'
        \ })
  let l:channel=job_getchannel(l:job)
  let l:channel_id=ch_info(l:channel)['id']
  let s:jobs[l:channel_id]={
        \   'channel_id': l:channel_id,
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

function! ferret#private#async#err_cb(channel, msg)
  let l:info=s:info_from_channel(a:channel)
  if type(l:info) == 4
    let l:lines=split(a:msg, '\n', 1)
    let l:count=len(l:lines)
    for l:i in range(l:count)
      let l:line=l:lines[l:i]
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

function! ferret#private#async#out_cb(channel, msg)
  let l:info=s:info_from_channel(a:channel)
  if type(l:info) == 4
    if !l:info.bang && l:info.result_count > s:limit
      call s:MaxResultsExceeded(l:info)
      return
    endif
    let l:lines=split(a:msg, '\n', 1)
    let l:count=len(l:lines)
    for l:i in range(l:count)
      let l:line=l:lines[l:i]
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

function! ferret#private#async#close_cb(channel) abort
  " Job may have been canceled with cancel_async. Do nothing in that case.
  let l:info=s:info_from_channel(a:channel)
  if type(l:info) == 4
    call remove(s:jobs, l:info.channel_id)
    call ferret#private#autocmd('FerretAsyncFinish')
    if !l:info.ack
      " If this is a :Lack search, try to focus appropriate window.
      call win_gotoid(l:info.window)
    endif
    call ferret#private#shared#finalize_search(l:info.output, l:info.ack)
    for l:error in l:info.errors
      unsilent echomsg l:error
    endfor
  endif
endfunction

function! ferret#private#async#pull() abort
  for l:channel_id in keys(s:jobs)
    let l:info=s:jobs[l:channel_id]
    call ferret#private#shared#finalize_search(l:info.output, l:info.ack)
  endfor
endfunction

function! ferret#private#async#cancel() abort
  let l:canceled=0
  for l:channel_id in keys(s:jobs)
    let l:info=s:jobs[l:channel_id]
    call job_stop(l:info.job)
    call remove(s:jobs, l:channel_id)
    let l:canceled=1
  endfor
  if l:canceled
    call ferret#private#autocmd('FerretAsyncFinish')
  endif
endfunction

" Stop a single job as a result of hitting g:FerretMaxResults.
function! s:MaxResultsExceeded(info)
  call ferret#private#shared#finalize_search(a:info.output, a:info.ack)
  call job_stop(a:info.job)
  call remove(s:jobs, a:info.channel_id)
  call ferret#private#autocmd('FerretAsyncFinish')
  call ferret#private#error(
        \   'Maximum result count exceeded. ' .
        \   'Either increase g:FerretMaxResults or ' .
        \   're-run the search with :Ack!, :Lack! etc.'
        \ )
endfunction

function! ferret#private#async#debug() abort
  return s:jobs
endfunction
