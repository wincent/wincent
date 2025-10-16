" SPDX-FileCopyrightText: © 2019 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Johann Klähn <kljohann@gmail.com>
" SPDX-FileCopyrightText: © 2009 Stefan Karrmann
" SPDX-FileCopyrightText: © 2005 Wolfgang Oertl
" SPDX-License-Identifier: GPL-2.0-or-later

scriptencoding utf-8

call ledger#init()

if exists('current_compiler')
  finish
endif

let current_compiler = b:ledger_bin

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:escaped_bin = substitute(b:ledger_bin, ' ', '\\ ', 'g')
let s:escaped_main = substitute(shellescape(expand(b:ledger_main)), ' ', '\\ ', 'g')
let s:escaped_extra = substitute(b:ledger_extra_options, ' ', '\\ ', 'g')

if !b:ledger_is_hledger
  " Capture Ledger errors (%-C ignores all lines between "While parsing..." and "Error:..."):
  CompilerSet errorformat=%EWhile\ parsing\ file\ \"%f\"\\,\ line\ %l:,%ZError:\ %m,%-C%.%#
  " Capture Ledger warnings:
  CompilerSet errorformat+=%tarning:\ \"%f\"\\,\ line\ %l:\ %m
  " Skip all other lines:
  CompilerSet errorformat+=%-G%.%#
  exe 'CompilerSet makeprg='
        \.s:escaped_bin
        \.'\ -f\ '.s:escaped_main
        \.'\ '.s:escaped_extra
        \.'\ source\ '.s:escaped_main
else
  exe 'CompilerSet makeprg='
        \.s:escaped_bin
        \.'\ -f\ '.s:escaped_main
        \.'\ check\ '.s:escaped_extra
  CompilerSet errorformat=hledger:\ %trror:\ %f:%l:%c:
  CompilerSet errorformat+=hledger:\ %trror:\ %f:%l:
  CompilerSet errorformat+=hledger:\ %trror:\ %f:%l-%.%#:
endif
