" Don't let built-in plug-in override our setting here.
let b:did_ftplugin=1
execute 'setlocal statusline=' . substitute(g:WincentQuickfixStatusline, '"', '\\"', 'g')

setlocal colorcolumn=
