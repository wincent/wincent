" SPDX-FileCopyrightText: © 2019 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Johann Klähn <kljohann@gmail.com>
" SPDX-FileCopyrightText: © 2009 Stefan Karrmann
" SPDX-FileCopyrightText: © 2005 Wolfgang Oertl
" SPDX-License-Identifier: GPL-2.0-or-later

scriptencoding utf-8

augroup ledger_file_detection
  autocmd!
  " Semi-canonical or common file extensions
  autocmd BufNewFile,BufRead *.journal,*.ledger,*.hledger setfiletype ledger

  " Deprecated or suspiciusly low usage extensions
  " TODO: Consider hiding these behind an off-by-default config flag
  autocmd BufNewFile,BufRead *.ldg,*.j, setfiletype ledger
augroup END
