" Keep quickfix result centered, if possible, when jumping from result to result.
cabbrev <expr> cn ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cn <bar> normal zz<cr>' : 'cn')
cabbrev <expr> cnf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cnf <bar> normal zz<cr>' : 'cnf')
cabbrev <expr> cp ((getcmdtype() == ':' && getcmdpos() == 3) ? 'cp <bar> normal zz<cr>' : 'cp')
cabbrev <expr> cpf ((getcmdtype() == ':' && getcmdpos() == 4) ? 'cpf <bar> normal zz<cr>' : 'cpf')
