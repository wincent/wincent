" Vim indent file
" Language:        YAML (with Ansible)
" Maintainer:      Benji Fisher, Ph.D. <benji@FisherFam.org>
" Author:          Chase Colman <chase@colman.io>
" Version:         1.0
" Latest Revision: 2014-11-18
" URL:             https://github.com/chase/vim-ansible-yaml

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setlocal sw=2 ts=2 sts=2 et
setlocal indentexpr=GetAnsibleIndent(v:lnum)
setlocal indentkeys=!^Fo,O,0#,<:>,-
setlocal nosmartindent

" Only define the function once.
if exists('*GetAnsibleIndent')
  finish
endif

function GetAnsibleIndent(lnum)
  " Check whether the user has set g:ansible_options["ignore_blank_lines"].
  let ignore_blanks = !exists('g:ansible_options["ignore_blank_lines"]')
	\ || g:ansible_options["ignore_blank_lines"]

  let prevlnum = ignore_blanks ? prevnonblank(a:lnum - 1) : a:lnum - 1
  if prevlnum == 0
    return 0
  endif
  let prevline = getline(prevlnum)

  let indent = indent(prevlnum)
  let increase = indent + &sw

  " Do not adjust indentation for comments
  if prevline =~ '\%(^\|\s\)#'
    return indent
  elseif prevline =~ ':\s*[>|]?$'
    return increase
  elseif prevline =~ ':$'
    return increase
  elseif prevline =~ '^\s*-\s*$'
    return increase
  elseif prevline =~ '^\s*-\s\+[^:]\+:\s*\S'
    return increase
  else
    return indent
  endif
endfunction
