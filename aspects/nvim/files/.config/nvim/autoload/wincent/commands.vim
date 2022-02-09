function! s:open(app, file)
  if !executable('open')
    echoerr 'No "open" executable'
    return
  endif

  silent execute '!open -a ' . shellescape(a:app) . ' ' . shellescape(a:file)
endfunction

" Map of .git directories to GitHub user-or-org/project identifiers.
let s:directories={}

function! s:open_on_github(file, range) abort
  let l:git_dir=wincent#git#get_git_dir(a:file)
  if l:git_dir == ''
    call wincent#functions#echoerr('No .git directory found above ' . a:file)
    return
  endif

  let l:key=l:git_dir
  let l:selected_remote='origin'
  if !has_key(s:directories, l:key)
    let s:directories[l:key]=-1

    try
      let l:remotes=system('git --git-dir=' . shellescape(l:git_dir) . ' remote -v')
      " Look for lines like these:
      "
      "   remote-a git@github.com:user-or-org/repo.git (...)
      "   remote-b https://github.com/user-or-org/repo.git (...)
      "
      for l:remote in ['github', 'upstream', 'upstream-rw', 'origin']
        let l:match=matchlist(
              \   l:remotes,
              \   '\(^\|\n\)' .
              \       l:remote .
              \       '\s\+\(git@github\.com:\|https://github\.com/\)\(\S\{-}\)\(\.git\)\?\s'
              \ )
        if len(l:match)
          let l:selected_remote=l:remote
          let s:directories[l:key]=l:match[3]
          break
        endif
      endfor
    catch
      " Cool, cool...
    endtry
  endif

  let l:address=s:directories[l:key]

  if l:address != -1
    let l:root=fnamemodify(l:git_dir, ':h')
    let l:relative_path=strcharpart(a:file, strchars(l:root))
    let l:branch=trim(system('git rev-parse --abbrev-ref HEAD'))
    if l:branch == 'HEAD'
      " Detached HEAD, so try to figure out default branch based on remote.
      let l:branch=trim(system('git rev-parse --abbrev-ref ' . l:selected_remote . '/HEAD'))
      if v:shell_error == 0
        let l:branch=strcharpart(l:branch, len(l:selected_remote) + 1)
      else
        " Give up, basically...
        let l:branch='main'
      endif
    endif
    let l:url='https://github.com/' . l:address . '/tree/' . l:branch . l:relative_path . a:range
    if fnamemodify(resolve(exepath('open')), ':t') == 'open'
      call system('open ' . shellescape(substitute(l:url, ' ', '%20', 'g')))
    else
      echomsg l:url
    endif
  endif
endfunction

function! s:marked(file) abort
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute '!xattr -d com.apple.quarantine ' . shellescape(a:file)
  call s:open('Marked 2.app', a:file)
endfunction

function! wincent#commands#find(args) abort
    set errorformat+=%f

    " TODO: make this async
    cexpr system('find ' . a:args)
endfunction

function! wincent#commands#glow(file) abort
  if !executable('glow')
    echoerr 'No glow executable found'
    return
  end
  if empty(a:file)
    let l:file=expand('%')
  else
    let l:file=a:file
  endif
  if !empty(l:file)
    let l:file=shellescape(l:file)
  endif

  " Make sure LESS doesn't include the problematic `F` option, which
  " causes the pager to exit immediately if output fits on less than one
  " screen.
  execute 'Spawn env LESS="-iMRX" glow --local --pager ' . l:file
endfunction

function! wincent#commands#lint() abort
  " TODO: make this smart about which compiler plug-in to used based on location

  " Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  compiler eslint

  " Do an immediate Make.
  Make
endfunction

function! wincent#commands#marked(file) abort
  if empty(a:file)
    call s:marked(expand('%'))
  else
    call s:marked(a:file)
  endif
endfunction

function! wincent#commands#open_on_github(...) abort range
  let l:range=''
  if a:0 == 0
    let l:files=[expand('%')]

    " Note: line numbers may not be accurate because we always open the HEAD of
    " the current branch.
    if visualmode() != ''
      if a:firstline == a:lastline
        let l:range='#L' . a:firstline
      else
        let l:range='#L' . a:firstline . '-L' . a:lastline
      endif
    endif
  else
    let l:files=a:000
  endif
  let l:did_open=0
  for l:file in l:files
    let l:file=fnamemodify(l:file, ':p')
    if l:file !=# ''
      call s:open_on_github(l:file, l:range)
      let l:did_open=1
    endif
  endfor
  if !l:did_open
    call wincent#functions#echoerr('No filename')
  endif
endfunction

function! wincent#commands#preview(file) abort
  if executable('open')
    call wincent#commands#marked(a:file)
  elseif executable('glow')
    call wincent#commands#glow(a:file)
  else
    echoerr 'No "open" or "glow" executable found'
  endif
endfunction

function! wincent#commands#typecheck() abort
  " Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  compiler tsc

  " Do an immediate Make.
  Make
endfunction

function! wincent#commands#vim() abort
  let l:filename=expand('%:p')
  if empty(l:filename)
    echoerr 'No current file'
    return
  endif

  let l:url=shellescape(l:filename)

  " Break up the string literal here to stop Vim from thinking it's a modeline
  " and freaking out with:
  "
  "   E518: Unknown option: //'
  "
  call system('open vim' . '://' . l:url)
endfunction
