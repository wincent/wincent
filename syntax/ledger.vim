" SPDX-FileCopyrightText: © 2019 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Johann Klähn <kljohann@gmail.com>
" SPDX-FileCopyrightText: © 2009 Stefan Karrmann
" SPDX-FileCopyrightText: © 2005 Wolfgang Oertl
" SPDX-License-Identifier: GPL-2.0-or-later

scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

call ledger#init()

" Force old regex engine (:help two-engines)
let s:oe = '\%#=1'
let s:lb1 = '\@1<='

let s:line_comment_chars = b:ledger_is_hledger ? ';*#' : ';|*#%'

let s:fb = b:ledger_fold_blanks
let s:skip = s:fb > 0 ? '\|^\n' : ''
if s:fb == 1
  let s:skip .= '\n\@!'
endif

let s:ledgerAmounts_contains = ''
let s:ledgerAccounts_contains = ''

if b:ledger_commodity_spell == 0
  let s:ledgerAmounts_contains .= '@NoSpell'
endif

if b:ledger_accounts_spell == 0
  let s:ledgerAccounts_contains .= '@NoSpell'
endif

" for debugging
syntax clear

" DATE[=EDATE] [*|!] [(CODE)] DESC <-- first line of transaction
"   ACCOUNT AMOUNT [; NOTE]  <-- posting

execute 'syntax region ledgerTransaction start=/^[[:digit:]~=]/ '.
      \ 'skip=/^\s'. s:skip . '/ end=/^/ fold keepend transparent '.
      \ 'contains=ledgerTransactionDate,ledgerTransactionMetadata,ledgerPosting,ledgerTransactionExpression'
syntax match ledgerTransactionDate /^\d\S\+/ contained
syntax match ledgerTransactionExpression /^[=~]\s\+\zs.*/ contained
syntax match ledgerPosting /^\s\+[^[:blank:];].*/
      \ contained transparent contains=ledgerAccount,ledgerAmount,ledgerValueExpression,ledgerPostingMetadata
" every space in an account name shall be surrounded by two non-spaces
" every account name ends with a tab, two spaces or the end of the line
execute 'syntax match ledgerAccount '.
      \ '/'.s:oe.'^\s\+\zs\%(\S'.s:lb1.' \S\|\S\)\+\ze\%(  \|\t\|\s*$\)/ contains='.s:ledgerAccounts_contains.' contained'
execute 'syntax match ledgerAmount '.
      \ '/'.s:oe.'\S'.s:lb1.'\%(  \|\t\)\s*\zs\%([^();[:space:]]\|\s\+[^();[:space:]]\)\+/ contains='.s:ledgerAmounts_contains.' contained'
execute 'syntax match ledgerValueExpression '.
      \ '/'.s:oe.'\S'.s:lb1.'\%(  \|\t\)\s*\zs(\%([^;[:space:]]\|\s\+[^;[:space:]]\)\+)/ contains='.s:ledgerAmounts_contains.' contained'

syntax region ledgerPreDeclaration start=/^\(account\|payee\|commodity\|tag\)/ skip=/^\s/ end=/^/
    \ keepend transparent
    \ contains=ledgerPreDeclarationType,ledgerPreDeclarationName,ledgerPreDeclarationDirective
syntax match ledgerPreDeclarationType /^\(account\|payee\|commodity\|tag\)/ contained
syntax match ledgerPreDeclarationName /^\S\+\s\+\zs.*/ contained
syntax match ledgerPreDeclarationDirective /^\s\+\zs\S\+/ contained

syntax match ledgerDirective
  \ /^\%(alias\|assert\|bucket\|capture\|check\|define\|expr\|fixed\|include\|year\)\s/
syntax match ledgerOneCharDirective /^\%(P\|A\|Y\|N\|D\|C\)\s/

syntax region ledgerBlockComment start=/^comment/ end=/^end comment/
syntax region ledgerBlockTest start=/^test/ end=/^end test/
execute 'syntax match ledgerComment /^['.s:line_comment_chars.'].*$/'

" Tags (metadata) are handled a bit differently in ledger-cli vs. hledger even
" though they both nested in comments the same way.
if b:ledger_is_hledger
  syntax region ledgerTransactionMetadata start=/;/ end=/^/
        \ keepend contained contains=ledgerTags
  syntax region ledgerPostingMetadata start=/;/ end=/^/
        \ keepend contained contains=ledgerTags
else
  syntax region ledgerTransactionMetadata start=/\%(\s\s\|\t\|^\s\+\);/ end=/^/
        \ keepend contained contains=ledgerTags,ledgerValueTag,ledgerTypedTag
  syntax region ledgerPostingMetadata start=/;/ end=/^/
        \ keepend contained contains=ledgerTags,ledgerValueTag,ledgerTypedTag
endif

" https://hledger.org/tags-tutorial.html
" https://www.ledger-cli.org/3.0/doc/ledger3.html#Metadata
if b:ledger_is_hledger
  syntax match ledgerTags /\v[[:alnum:]_-]+:[^,;]*/
      \ contained contains=ledgerTag
  syntax match ledgerTag /\v[[:alnum:]_-]+/ contained nextgroup=ledgerTagDef
  syntax match ledgerTagDef ":" contained nextgroup=ledgerTagValue,ledgerTagSep
  syntax match ledgerTagValue /\v[^,;]+/ contained nextgroup=ledgerTagSep
  syntax match ledgerTagSep /,/ contained
else
  execute 'syntax match ledgerTags '.
      \ '/'.s:oe.'\%(\%(;\s*\|^tag\s\+\)\)\@<='.
      \ ':[^:[:space:]][^:]*\%(::\?[^:[:space:]][^:]*\)*:\s*$/ '.
      \ 'contained contains=ledgerTag'
  syntax match ledgerTag /:\zs[^:]\+\ze:/ contained
  execute 'syntax match ledgerValueTag '.
    \ '/'.s:oe.'\%(\%(;\|^tag\)[^:]\+\)\@<=[^:]\+:\ze.\+$/ contained'
  execute 'syntax match ledgerTypedTag '.
    \ '/'.s:oe.'\%(\%(;\|^tag\)[^:]\+\)\@<=[^:]\+::\ze.\+$/ contained'
endif

syntax region ledgerApply
    \ matchgroup=ledgerStartApply start=/^apply\>/
    \ matchgroup=ledgerEndApply end=/^end\s\+apply\>/
    \ contains=ledgerApplyHead,ledgerApply,ledgerTransaction,ledgerComment
execute 'syntax match ledgerApplyHead '.
      \ '/'.s:oe.'\%(^apply\s\+\)\@<=\S.*$/ contained'

syntax keyword ledgerTodo FIXME TODO
      \ contained containedin=ledgerComment,ledgerTransaction,ledgerTransactionMetadata,ledgerPostingMetadata

highlight default link ledgerComment Comment
highlight default link ledgerBlockComment Comment
highlight default link ledgerBlockTest Comment
highlight default link ledgerTransactionDate Constant
highlight default link ledgerTransactionExpression Statement
highlight default link ledgerTransactionMetadata Tag
highlight default link ledgerPostingMetadata Tag
highlight default link ledgerTypedTag Keyword
highlight default link ledgerValueTag Type
highlight default link ledgerTag Type
highlight default link ledgerTagValue Label
highlight default link ledgerTagDef Delimiter
highlight default link ledgerTagSep Delimiter
highlight default link ledgerStartApply Tag
highlight default link ledgerEndApply Tag
highlight default link ledgerApplyHead Type
highlight default link ledgerAccount Identifier
highlight default link ledgerAmount Number
highlight default link ledgerValueExpression Function
highlight default link ledgerPreDeclarationType Type
highlight default link ledgerPreDeclarationName Identifier
highlight default link ledgerPreDeclarationDirective Type
highlight default link ledgerDirective Type
highlight default link ledgerOneCharDirective Type
highlight default link ledgerTodo Todo

" syncinc is easy: search for the first transaction.
syntax sync clear
syntax sync match ledgerSync grouphere ledgerTransaction "^[[:digit:]~=]"

let b:current_syntax = b:ledger_is_hledger ? 'hledger' : 'ledger'
