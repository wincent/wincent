let g:projectionist_heuristics = {
      \   '*': {
      \     '*.js': {
      \       'alternate': '{dirname}/__tests__/{basename}-test.js',
      \       'type': 'source'
      \     },
      \     '**/__tests__/*-test.js': {
      \       'alternate': '{dirname}/{basename}.js',
      \       'type': 'test'
      \     }
      \   }
      \ }
