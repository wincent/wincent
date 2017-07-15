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
      \     '*.js': {
      \       'alternate': [
      \         '{dirname}/{basename}.test.js',
      \         '{dirname}/__tests__/{basename}-test.js',
      \         '{dirname}/__tests__/{basename}-mocha.js'
      \       ],
      \       'type': 'source'
      \     },
      \     '*.test.js': {
      \       'alternate': '{basename}.js',
      \       'type': 'test',
      \     },
      \     '**/__tests__/*-mocha.js': {
      \       'alternate': '{dirname}/{basename}.js',
      \       'type': 'test'
      \     },
      \     '**/__tests__/*-test.js': {
      \       'alternate': '{dirname}/{basename}.js',
      \       'type': 'test'
      \     },
      \     '*.re': {
      \       'alternate': [
      \         '{}_test.re',
      \         '{}.rei'
      \       ],
      \       'type': 'source'
      \     },
      \     '*.rei': {
      \       'alternate': [
      \         '{}.re',
      \         '{}_test.re',
      \       ],
      \       'type': 'header'
      \     },
      \     '*_test.re': {
      \       'alternate': [
      \         '{}.rei',
      \         '{}.re',
      \       ],
      \       'type': 'test'
      \     }
      \   }
      \ }
