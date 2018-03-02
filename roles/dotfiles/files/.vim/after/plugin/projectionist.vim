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
