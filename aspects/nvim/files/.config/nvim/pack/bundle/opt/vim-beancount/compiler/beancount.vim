if exists('g:current_compiler')
    finish
endif
let g:current_compiler = 'beancount'

if exists(':CompilerSet') != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpoptions
set cpoptions-=C

CompilerSet makeprg=bean-check\ %
CompilerSet errorformat=%-G         " Skip blank lines
CompilerSet errorformat+=%f:%l:\ %m  " File:line: message
CompilerSet errorformat+=%-G\ %.%#   " Skip indented lines.

let &cpoptions = s:cpo_save
unlet s:cpo_save
