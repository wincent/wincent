if exists("g:__CABAL_XPT_VIM__")
    finish
endif
let g:__CABAL_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT infos hint=Name:\ Version\: Synopsys:\ Descr:\ Author:\ ...
XSET Description...|post=\nDescription: `_^
XSET Author...|post=\nAuthor: `_^
XSET Maintainer...|post=\nMaintainer: `_^
Name:       `name^
Version:    `ver^
Synopsis:   `synop^ 
Build-Type: `Simple^
Cabal-Version: >= `ver^1.2^`
`Description...^`
`Author...^`
`Maintainer...^

XPT if hint=if\ ...\ else\ ...
if `cond^
    `what^
`else...^else
    \`cursor\^^^


XPT lib hint=library\ Exposed-Modules...
library
  Exposed-Modules: `_^^`...0^
                   `_^^`...0^
  Build-Depends: base >= `ver^2.0^`...1^, `_^^`...1^

XPT exe hint=Main-Is:\ ..\ Build-Depends
Executable `execName^
    Main-Is: `mainFile^
    Build-Depends: base >= `ver^2.0^`...1^, `_^^`...1^

