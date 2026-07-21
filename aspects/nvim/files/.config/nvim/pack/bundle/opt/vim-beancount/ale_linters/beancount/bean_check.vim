fun <SID>GetCommand(a)
  return 'bean-check ' . (exists('b:beancount_root') ? b:beancount_root : '%s')
endfun

function! <SID>HandleBeancountLint(buffer, lines) abort
  let l:pattern = '\v^([^:]+):(\d+):?(\d+)?:? ?(.+)$'
  let l:output = []

  let l:matches = ale#util#GetMatches(a:lines, l:pattern)
  for l:match in l:matches
    let l:file = l:match[1]
    let l:lnum = l:match[2] + 0
    let l:text = trim(l:match[4])
    if (l:file != expand('%:p'))
      " This error is for a different file, so assign it to line 0 and prepend
      " the culprit filename to the lint text
      let l:lnum = 0
      let l:relativefile = fnamemodify(l:file, ':.')
      let l:text = '('.l:relativefile.') '.l:text
    endif
    call add(l:output, {
          \   'lnum': l:lnum,
          \   'text': l:text,
          \   'type': 'E',
          \})
  endfor
  return l:output
endfunction

call ale#linter#Define('beancount', {
\   'name': 'bean_check',
\   'output_stream': 'stderr',
\   'executable': 'bean-check',
\   'command': function('<SID>GetCommand'),
\   'callback': function('<SID>HandleBeancountLint'),
\})
