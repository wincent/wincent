" Location:     plugin/projectionist.vim
" Author:       Tim Pope <http://tpo.pe/>
" Version:      1.3
" GetLatestVimScripts: 4989 1 :AutoInstall: projectionist.vim

if exists("g:loaded_projectionist") || v:version < 704 || &cp
  finish
endif
let g:loaded_projectionist = 1

" ProjectionistHas('Gemfile&lib/|*.gemspec', '/path/to/root')
function! ProjectionistHas(req, ...) abort
  if type(a:req) != type('')
    return
  endif
  let ns = matchstr(a:0 ? a:1 : a:req, '^\a\a\+\ze:')
  if !a:0
    return s:nscall(ns, a:req =~# '[\/]$' ? 'isdirectory' : 'filereadable', a:req)
  endif
  for test in split(a:req, '|')
    if s:has(ns, a:1, test)
      return 1
    endif
  endfor
endfunction

let s:slash = exists('+shellslash') ? '\' : '/'

if !exists('g:projectionist_heuristics')
  let g:projectionist_heuristics = {}
endif

function! s:nscall(ns, fn, path, ...) abort
  if !get(g:, 'projectionist_ignore_' . a:ns)
    return call(get(get(g:, 'io_' . a:ns, {}), a:fn, a:fn), [a:path] + a:000)
  else
    return call(a:fn, [a:path] + a:000)
  endif
endfunction

function! s:has(ns, root, requirements) abort
  if empty(a:requirements)
    return 0
  endif
  for test in split(a:requirements, '&')
    let relative = '/' . matchstr(test, '[^!/].*')
    if relative =~# '\*'
      let found = !empty(s:nscall(a:ns, 'glob', escape(a:root, '[?*') . relative))
    elseif relative =~# '/$'
      let found = s:nscall(a:ns, 'isdirectory', a:root . relative)
    else
      let found = s:nscall(a:ns, 'filereadable', a:root . relative)
    endif
    if test =~# '^!' ? found : !found
      return 0
    endif
  endfor
  return 1
endfunction

function! s:IsAbs(path) abort
  return tr(a:path, s:slash, '/') =~# '^/\|^\a\+:'
endfunction

function! s:Detect(...) abort
  let b:projectionist = {}
  unlet! b:projectionist_file
  if a:0
    let file = a:1
  elseif &l:buftype =~# '^\%(nowrite\)\=$' && len(@%) || &l:buftype =~# '^\%(nofile\|acwrite\)' && s:IsAbs(@%)
    let file = @%
  else
    return
  endif
  if !s:IsAbs(file)
    let s = exists('+shellslash') && !&shellslash ? '\' : '/'
    let file = substitute(getcwd(), '\' . s . '\=$', s, '') . file
  endif
  let file = substitute(file, '[' . s:slash . '/]$', '', '')

  try
    if exists('*ExcludeBufferFromDiscovery') && ExcludeBufferFromDiscovery(file, 'projectionist')
      return
    endif
  catch
  endtry
  let ns = matchstr(file, '^\a\a\+\ze:')
  if empty(ns)
    let file = resolve(file)
  elseif get(g:, 'projectionist_ignore_' . ns)
    return
  endif
  let root = file
  if empty(ns) && !isdirectory(root)
    let root = fnamemodify(root, ':h')
  endif
  let previous = ""
  while root !=# previous && root !~# '^\.\=$\|^[\/][\/][^\/]*$'
    if s:nscall(ns, 'filereadable', root . '/.projections.json')
      try
        let value = projectionist#json_parse(projectionist#readfile(root . '/.projections.json'))
        call projectionist#append(root, value)
      catch /^invalid JSON:/
      endtry
    endif
    for [key, value] in items(g:projectionist_heuristics)
      for test in split(key, '|')
        if s:has(ns, root, test)
          call projectionist#append(root, value)
          break
        endif
      endfor
    endfor
    let previous = root
    let root = fnamemodify(root, ':h')
  endwhile

  if exists('#User#ProjectionistDetect')
    try
      let g:projectionist_file = file
      doautocmd <nomodeline> User ProjectionistDetect
    finally
      unlet! g:projectionist_file
    endtry
  endif

  if !empty(b:projectionist)
    let b:projectionist_file = file
    call projectionist#activate()
  endif
endfunction

if !exists('g:did_load_ftplugin')
  filetype plugin on
endif

augroup projectionist
  autocmd!
  autocmd FileType *
        \ if &filetype !=# 'netrw' |
        \   call s:Detect() |
        \ elseif !exists('b:projectionist') |
        \   call s:Detect(get(b:, 'netrw_curdir', @%)) |
        \ endif
  autocmd BufFilePost *
        \ if type(getbufvar(+expand('<abuf>'), 'projectionist')) == type({}) |
        \   call s:Detect(expand('<afile>')) |
        \ endif
  autocmd BufNewFile,BufReadPost *
        \ if empty(&filetype) |
        \   call s:Detect() |
        \ endif
  autocmd CmdWinEnter *
        \ if !empty(getbufvar('#', 'projectionist_file')) |
        \   let b:projectionist_file = getbufvar('#', 'projectionist_file') |
        \   let b:projectionist = getbufvar('#', 'projectionist') |
        \   call projectionist#activate() |
        \ endif
  autocmd User NERDTreeInit,NERDTreeNewRoot
        \ if exists('b:NERDTree.root.path.str') |
        \   call s:Detect(b:NERDTree.root.path.str()) |
        \ endif
  autocmd VimEnter *
        \ if get(g:, 'projectionist_vim_enter', 1) && argc() == 0 && empty(v:this_session) |
        \   call s:Detect(getcwd()) |
        \ endif
  autocmd BufWritePost .projections.json call s:Detect(expand('<afile>'))
  autocmd BufNewFile *
        \ if !empty(get(b:, 'projectionist')) |
        \   call projectionist#apply_template() |
        \ endif
augroup END
