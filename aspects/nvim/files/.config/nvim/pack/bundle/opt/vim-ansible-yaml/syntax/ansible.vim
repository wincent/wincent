" Vim syntax file
" Language:        YAML (with Ansible)
" Maintainer:      Benji Fisher, Ph.D. <benji@FisherFam.org>
" Author:          Chase Colman <chase@colman.io>
" Version:         1.0
" Latest Revision: 2014-06-28
" URL:             https://github.com/chase/vim-ansible-yaml

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'ansible'
endif

" Load YAML syntax
source <sfile>:p:h/include/yaml.vim
unlet b:current_syntax

source <sfile>:p:h/include/jinja.vim
unlet b:current_syntax

syn case match

syn match ansibleRepeat '\<with_\w\+\>' contained containedin=yamlKey
syn keyword ansibleConditional when changed_when  contained containedin=yamlKey
syn region ansibleString  start='"' end='"' skip='\\"' display contains=jinjaVarBlock

if version >= 508 || !exist("did_ansible_syn")
  if version < 508
    let did_ansible_syn = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ansibleConditional Statement
  HiLink ansibleRepeat Repeat
  HiLink ansibleString String

  delcommand HiLink
endif

let b:current_syntax = 'ansible'

if main_syntax == 'ansible'
  unlet main_syntax
endif
