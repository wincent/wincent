" Keep quickfix result centered, if possible, when jumping from result to result.
cabbrev <silent> <expr> cn ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cn <bar> normal zz<cr>' : 'cn')
cabbrev <silent> <expr> cnf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cnf <bar> normal zz<cr>' : 'cnf')
cabbrev <silent> <expr> cp ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cp <bar> normal zz<cr>' : 'cp')
cabbrev <silent> <expr> cpf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cpf <bar> normal zz<cr>' : 'cpf')
