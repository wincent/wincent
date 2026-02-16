" SPDX-FileCopyrightText: © 2019 Caleb Maclennan <caleb@alerque.com>
" SPDX-FileCopyrightText: © 2009 Johann Klähn <kljohann@gmail.com>
" SPDX-FileCopyrightText: © 2009 Stefan Karrmann
" SPDX-FileCopyrightText: © 2005 Wolfgang Oertl
" SPDX-License-Identifier: GPL-2.0-or-later

scriptencoding utf-8

call ledger#init()

if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

let b:undo_ftplugin = 'setlocal '.
                    \ 'foldtext< '.
                    \ 'include< comments< commentstring< omnifunc< formatexpr< formatprg<'

setlocal foldtext=LedgerFoldText()
setlocal include=^!\\?include
setlocal comments=b:;
setlocal commentstring=;%s
setlocal omnifunc=LedgerComplete
setlocal formatexpr=ledger#align_formatexpr(v:lnum,v:count)

" Automatic formatting is disabled by default because it can cause data loss when run
" on non-transaction blocks, see https://github.com/ledger/vim-ledger/issues/168.
if b:ledger_dangerous_formatprg
  execute 'setlocal formatprg='.substitute(b:ledger_bin, ' ', '\\ ', 'g').'\ -f\ -\ print'
  setlocal formatexpr=
endif

if !exists('current_compiler')
  compiler ledger
endif

" Highlight groups for Ledger reports
highlight default link LedgerNumber Number
highlight default link LedgerNegativeNumber Special
highlight default link LedgerCleared Constant
highlight default link LedgerPending Todo
highlight default link LedgerTarget Statement
highlight default link LedgerImproperPerc Special

let s:currency_symbol = '[[:alpha:]¢$€£]\+'
let s:value_regex = '\('.
             \   '\%([0-9]\+\)'.
             \   '\%([,.][0-9]\+\)*'.
             \ '\|'.
             \   '[,.][0-9]\+'.
             \ '\)'
let s:optional_sign = '[+-]\?'
let s:currency_sign = '\('.
             \   s:optional_sign.
             \   '\s*'.
             \   s:currency_symbol.
             \ '\|'.
             \   s:currency_symbol.
             \   '\s*'.
             \   s:optional_sign.
             \ '\)'

let s:optional_balance_assertion = '\(\s*=\s*'.s:currency_sign.'\s*'.s:value_regex.'\)\?'

let s:rx_amount = s:value_regex.
                \ s:optional_balance_assertion.
                \ '\s*\%('.s:currency_symbol.'\s*\)\?'.
                \ '\%(\s*;.*\)\?$'

function! LedgerFoldText()
  " find amount
  let amount = ''
  let line_number = v:foldstart + 1
  while line_number <= v:foldend
    let line = getline(line_number)

    " Skip metadata/leading comment
    if line !~# '^\%(\s\+;\|\d\)'
      " No comment, look for amount...
      let groups = matchlist(line, s:rx_amount)
      if ! empty(groups)
        let amount = groups[1]
        break
      endif
    endif
    let line_number += 1
  endwhile

  " strip whitespace at beginning and end of line
  let foldtext = substitute(getline(v:foldstart),
                          \ '\(^\s\+\|\s\+$\)', '', 'g')

  " number of columns foldtext can use
  let columns = s:get_columns()
  if b:ledger_maxwidth
    let columns = min([columns, b:ledger_maxwidth])
  endif

  let amount = printf(' %s ', amount)
  " left cut-off if window is too narrow to display the amount
  while columns < strdisplaywidth(amount)
    let amount = substitute(amount, '^.', '', '')
  endwhile
  let columns -= strdisplaywidth(amount)

  if columns <= 0
    return amount
  endif

  " right cut-off if there is not sufficient space to display the description
  while columns < strdisplaywidth(foldtext)
    let foldtext = substitute(foldtext, '.$', '', '')
  endwhile
  let columns -= strdisplaywidth(foldtext)

  if columns <= 0
    return foldtext . amount
  endif

  " fill in the fillstring
  if strlen(b:ledger_fillstring)
    let fillstring = b:ledger_fillstring
  else
    let fillstring = ' '
  endif
  let fillstrlen = strdisplaywidth(fillstring)

  let foldtext .= ' '
  let columns -= 1
  while columns >= fillstrlen
    let foldtext .= fillstring
    let columns -= fillstrlen
  endwhile

  while columns < strdisplaywidth(fillstring)
    let fillstring = substitute(fillstring, '.$', '', '')
  endwhile
  let foldtext .= fillstring

  return foldtext . amount
endfunction

function! LedgerComplete(findstart, base)
  if a:findstart
    let line_number = line('.')
    let line = getline('.')
    let b:completion_context = ''
    if line =~# '^\s\+[^[:blank:];]'
      " only allow completion when in or at end of account name
      if matchend(line, '^\s\+\%(\S \S\|\S\)\+') >= col('.') - 1
        " the start of the first non-blank character
        " (excluding virtual-transaction and 'cleared' marks)
        " is the beginning of the account name
        let b:completion_context = 'account'
        return matchend(line, '^\s\+[*!]\?\s*[\[(]\?')
      endif
    elseif line =~# '^account '
        let prefix = matchend(line, '^account ')
        let b:completion_context = 'account'
        return prefix
    elseif line =~# '^\d'
      let prefix = matchend(line, '^\d\S\+\%\(\s\(([^\)]*)\|[*?!]\)\)\?\s\+')
      if prefix <= col('.') - 1
        let b:completion_context = 'description'
        if prefix == -1
          return -3
        endif
        return prefix
      endif
    elseif b:ledger_is_hledger && line =~# '^payee '
      let prefix = matchend(line, '^payee ')
      let b:completion_context = 'description'
      return prefix
    elseif line =~# '^$'
      let b:completion_context = 'new'
      return 0
    endif
    return -3
  else
    if ! exists('b:completion_cache')
      let b:completion_cache = s:collect_completion_data()
      let b:completion_cache['#'] = changenr()
    endif
    let update_cache = 0

    let results = []
    if b:completion_context ==# 'account'
      let hierarchy = split(a:base, ':')
      if a:base =~# ':$'
        call add(hierarchy, '')
      endif

      let results = ledger#find_in_tree(b:completion_cache.accounts, hierarchy)
      let exacts = filter(copy(results), 'v:val[1]')

      if len(exacts) < 1
        " update cache if we have no exact matches
        let update_cache = 1
      endif

      if b:ledger_exact_only
        let results = exacts
      endif

      call map(results, 'v:val[0]')

      if b:ledger_fuzzy_account_completion
        let results = matchfuzzy(b:completion_cache.flat_accounts, a:base, {'matchseq':1})
      elseif b:ledger_detailed_first
        let results = reverse(sort(results, 's:sort_accounts_by_depth'))
      else
        let results = sort(results)
      endif
    elseif b:completion_context ==# 'description'
      let results = ledger#filter_items(b:completion_cache.descriptions, a:base)

      if len(results) < 1
        let update_cache = 1
      endif
    elseif b:completion_context ==# 'new'
      return [strftime(b:ledger_date_format)]
    endif


    if b:ledger_include_original
      call insert(results, a:base)
    endif

    " no completion (apart from a:base) found. update cache if file has changed
    if update_cache && b:completion_cache['#'] != changenr()
      unlet b:completion_cache
      return LedgerComplete(a:findstart, a:base)
    else
      unlet! b:completion_context
      return results
    endif
  endif
endfunction

function! s:collect_completion_data()
  let transactions = ledger#transactions()
  let cache = {'descriptions': [], 'tags': {}, 'accounts': {}, 'flat_accounts': []}

  let accounts = s:get_accounts_list()
  let cache.flat_accounts = accounts
  let cache.descriptions = s:get_descriptions_list()

  for transaction in transactions
    let [tags, postings] = transaction.parse_body()
    let tagdicts = [tags]

    " collect account names (only when not using ledger binary)
    if b:ledger_bin ==# v:false
      for posting in postings
        if has_key(posting, 'tags')
          call add(tagdicts, posting.tags)
        endif
        " remove virtual-transaction-marks
        let name = substitute(posting.account, '^\s*|\s*$', '', 'g')
        let name = substitute(name, '^(.*)$', '\1', '')
        let name = substitute(name, '^\[.*\]$', '\1', '')
        if index(accounts, name) < 0
          call add(accounts, name)
        endif
      endfor
    endif

    " collect tags
    for tags in tagdicts | for [tag, val] in items(tags)
      let values = get(cache.tags, tag, [])
      if index(values, val) < 0
        call add(values, val)
      endif
      let cache.tags[tag] = values
    endfor | endfor
  endfor

  for account in accounts
    let last = cache.accounts
    for part in split(account, ':')
      let last[part] = get(last, part, {})
      let last = last[part]
    endfor
  endfor

  return cache
endfunction

function! s:get_accounts_list()
  if b:ledger_bin !=# v:false
    return split(system(b:ledger_accounts_cmd), '\n')
  else
    return ledger#declared_accounts()
  endif
endfunction

function! s:get_descriptions_list()
  if b:ledger_bin !=# v:false
    return split(system(b:ledger_descriptions_cmd), '\n')
  else
    let transactions = ledger#transactions()
    let descriptions = []
    for xact in transactions
      if has_key(xact, 'description') && index(descriptions, xact['description']) < 0
        call add(descriptions, xact['description'])
      endif
    endfor
    return descriptions
  endif
endfunction

" Helper functions

" get # of visible/usable columns in current window
function! s:get_columns()
  " As long as vim doesn't provide a command natively,
  " we have to compute the available columns.
  " see :help todo.txt -> /Add argument to winwidth()/

  let columns = (winwidth(0) == 0 ? 80 : winwidth(0)) - &foldcolumn
  if &number
    " line('w$') is the line number of the last line
    let columns -= max([len(line('w$'))+1, &numberwidth])
  endif

  " are there any signs/is the sign column displayed?
  redir => signs
  silent execute 'sign place buffer='.string(bufnr('%'))
  redir END
  if signs =~# 'id='
    let columns -= 2
  endif

  return columns
endfunction

function! s:sort_accounts_by_depth(name1, name2)
  let depth1 = s:count_expression(a:name1, ':')
  let depth2 = s:count_expression(a:name2, ':')
  return depth1 == depth2 ? 0 : depth1 > depth2 ? 1 : -1
endfunction

function! s:count_expression(text, expression)
  return len(split(a:text, a:expression, 1))-1
endfunction

function! s:autocomplete_account_or_payee(argument_lead, command_line, cursor_position)
  if a:argument_lead =~# '^@'
    let payees = s:get_descriptions_list()
    let pattern = strpart(a:argument_lead, 1)
    return map(filter(payees, "v:val =~? '" . pattern . "' && v:val !~? '^Warning: '"),
             \ '"@" . escape(v:val, " ")')
  else
    let accounts = s:get_accounts_list()
    return map(filter(accounts, "v:val =~? '" . a:argument_lead . "' && v:val !~? '^Warning: '"),
             \ 'escape(v:val, " ")')
  endif
endfunction

function! s:reconcile(file, account)
  let l:amount = input('Target amount' . (empty(b:ledger_default_commodity) ? ': ' : ' (' . b:ledger_default_commodity . '): '))
  call ledger#reconcile(a:file, a:account, str2float(l:amount))
endfunction

" Commands
command! -buffer -nargs=? -complete=customlist,<SID>autocomplete_account_or_payee
      \ Balance call ledger#show_balance(b:ledger_main, <q-args>)

command! -buffer -nargs=+ -complete=customlist,<SID>autocomplete_account_or_payee
      \ Ledger call ledger#output(ledger#report(b:ledger_main, <q-args>))

command! -buffer -range LedgerAlign <line1>,<line2>call ledger#align_commodity()

command! -buffer LedgerAlignBuffer call ledger#align_commodity_buffer()

command! -buffer -nargs=1 -complete=customlist,<SID>autocomplete_account_or_payee
      \ Reconcile call <SID>reconcile(b:ledger_main, <q-args>)

command! -buffer -complete=customlist,<SID>autocomplete_account_or_payee -nargs=*
      \ Register call ledger#register(b:ledger_main, <q-args>)
