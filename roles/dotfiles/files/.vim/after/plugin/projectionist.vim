let g:projectionist_heuristics = {
      \   '*': {
      \     '*.c': {
      \       'alternate': '{}.h',
      \       'type': 'source'
      \     },
      \     '*.h': {
      \       'alternate': '{}.c',
      \       'type': 'header'
      \     },
      \
      \     'src/*.re': {
      \       'alternate': [
      \         '__tests__/{}_test.re',
      \         'src/{}_test.re',
      \         'src/{}.rei'
      \       ],
      \       'type': 'source'
      \     },
      \     'src/*.rei': {
      \       'alternate': [
      \         'src/{}.re',
      \         '__tests__/{}_test.re',
      \         'src/{}_test.re',
      \       ],
      \       'type': 'header'
      \     },
      \     '__tests__/*_test.re': {
      \       'alternate': [
      \         'src/{}.rei',
      \         'src/{}.re',
      \       ],
      \       'type': 'test'
      \     }
      \   }
      \ }

" Set up projections for JS variants.
function! s:Callback(idx, extension)
  let g:projectionist_heuristics['*']['*' . a:extension] = {
      \       'alternate': [
      \         '{dirname}/{basename}.test' . a:extension,
      \         '{dirname}/__tests__/{basename}-test' . a:extension,
      \         '{dirname}/__tests__/{basename}-mocha' . a:extension
      \       ],
      \       'type': 'source'
      \     }
  let g:projectionist_heuristics['*']['*.test' . a:extension] = {
      \       'alternate': '{basename}' . a:extension,
      \       'type': 'test',
      \     }
  let g:projectionist_heuristics['*']['**/__tests__/*-test' . a:extension] = {
      \       'alternate': '{dirname}/{basename}.ts',
      \       'type': 'test'
      \     }
  let g:projectionist_heuristics['*']['**/__tests__/*-mocha' . a:extension] = {
      \       'alternate': '{dirname}/{basename}' . a:extension,
      \       'type': 'test'
      \     }
endfunction

call map(['.js', '.jsx', '.ts', '.tsx'], function ('s:Callback'))

" Provide config for repos where I:
"
" - want special config
" - don't want to (or can't) commit a custom ".projections.json" file
" - can't set useful heuristics based on what's in the root directory
"
function! s:UpdateProjections()
  let l:cwd=getcwd()
  if l:cwd == expand('~/code/liferay-npm-tools')
    function! s:Callback(idx, pkg)
      let g:projectionist_heuristics['*'][a:pkg . '/src/*.js'] = {
        \   'alternate': a:pkg . '/__tests__/{}.js',
        \   'type': 'source'
        \ }
      let g:projectionist_heuristics['*'][a:pkg . '/__tests__/*.js'] = {
        \   'alternate': a:pkg . '/src/{}.js',
        \   'type': 'test'
        \ }
    endfunction

    call map(glob('packages/*', 0, 1), function('s:Callback'))
  endif
endfunction

call s:UpdateProjections()

if has('autocmd')
  augroup WincentProjectionist
    autocmd!
    autocmd DirChanged * call <SID>UpdateProjections()
  augroup END
endif
