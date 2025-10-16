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

let s:cursym = '[[:alpha:]¢$€£]\+'
let s:valreg = '\('.
             \   '\%([0-9]\+\)'.
             \   '\%([,.][0-9]\+\)*'.
             \ '\|'.
             \   '[,.][0-9]\+'.
             \ '\)'
let s:optsgn = '[+-]\?'
let s:cursgn = '\('.
             \   s:optsgn.
             \   '\s*'.
             \   s:cursym.
             \ '\|'.
             \   s:cursym.
             \   '\s*'.
             \   s:optsgn.
             \ '\)'

let s:optional_balance_assertion = '\(\s*=\s*'.s:cursgn.'\s*'.s:valreg.'\)\?'

let s:rx_amount = s:valreg.
                \ s:optional_balance_assertion.
                \ '\s*\%('.s:cursym.'\s*\)\?'.
                \ '\%(\s*;.*\)\?$'

function! LedgerFoldText()
  " find amount
  let amount = ''
  let lnum = v:foldstart + 1
  while lnum <= v:foldend
    let line = getline(lnum)

    " Skip metadata/leading comment
    if line !~# '^\%(\s\+;\|\d\)'
      " No comment, look for amount...
      let groups = matchlist(line, s:rx_amount)
      if ! empty(groups)
        let amount = groups[1]
        break
      endif
    endif
    let lnum += 1
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
    let lnum = line('.')
    let line = getline('.')
    let b:compl_context = ''
    if line =~# '^\s\+[^[:blank:];]'
      " only allow completion when in or at end of account name
      if matchend(line, '^\s\+\%(\S \S\|\S\)\+') >= col('.') - 1
        " the start of the first non-blank character
        " (excluding virtual-transaction and 'cleared' marks)
        " is the beginning of the account name
        let b:compl_context = 'account'
        return matchend(line, '^\s\+[*!]\?\s*[\[(]\?')
      endif
    elseif line =~# '^\d'
      let pre = matchend(line, '^\d\S\+\%(([^)]*)\|[*?!]\|\s\)\+')
      if pre < col('.') - 1
        let b:compl_context = 'description'
        return pre
      endif
    elseif line =~# '^$'
      let b:compl_context = 'new'
    endif
    return -1
  else
    if ! exists('b:compl_cache')
      let b:compl_cache = s:collect_completion_data()
      let b:compl_cache['#'] = changenr()
    endif
    let update_cache = 0

    let results = []
    if b:compl_context ==# 'account'
      let hierarchy = split(a:base, ':')
      if a:base =~# ':$'
        call add(hierarchy, '')
      endif

      let results = ledger#find_in_tree(b:compl_cache.accounts, hierarchy)
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
        let results = matchfuzzy(b:compl_cache.flat_accounts, a:base, {'matchseq':1})
      elseif b:ledger_detailed_first
        let results = reverse(sort(results, 's:sort_accounts_by_depth'))
      else
        let results = sort(results)
      endif
    elseif b:compl_context ==# 'description'
      let results = ledger#filter_items(b:compl_cache.descriptions, a:base)

      if len(results) < 1
        let update_cache = 1
      endif
    elseif b:compl_context ==# 'new'
      return [strftime(b:ledger_date_format)]
    endif


    if b:ledger_include_original
      call insert(results, a:base)
    endif

    " no completion (apart from a:base) found. update cache if file has changed
    if update_cache && b:compl_cache['#'] != changenr()
      unlet b:compl_cache
      return LedgerComplete(a:findstart, a:base)
    else
      unlet! b:compl_context
      return results
    endif
  endif
endfunction

function! s:collect_completion_data()
  let transactions = ledger#transactions()
  let cache = {'descriptions': [], 'tags': {}, 'accounts': {}, 'flat_accounts': []}
  if b:ledger_bin
    let accounts = split(system(b:ledger_accounts_cmd), '\n')
  else
    let accounts = ledger#declared_accounts()
  endif
  let cache.flat_accounts = accounts
  if b:ledger_bin
    let cache.descriptions = split(system(b:ledger_descriptions_cmd), '\n')
  endif
  for xact in transactions
    if !b:ledger_bin
      " collect descriptions
      if has_key(xact, 'description') && index(cache.descriptions, xact['description']) < 0
        call add(cache.descriptions, xact['description'])
      endif
    endif
    let [t, postings] = xact.parse_body()
    let tagdicts = [t]

		" collect account names
    if !b:ledger_bin
      for posting in postings
        if has_key(posting, 'tags')
          call add(tagdicts, posting.tags)
        endif
        " remove virtual-transaction-marks
        let name = substitute(posting.account, '\%(^\s*[\[(]\?\|[\])]\?\s*$\)', '', 'g')
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

" Helper functions

" return length of string with fix for multibyte characters
function! s:multibyte_strlen(text)
   return strlen(substitute(a:text, '.', 'x', 'g'))
endfunction

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

function! s:autocomplete_account_or_payee(argLead, cmdLine, cursorPos)
  return (a:argLead =~# '^@') ?
        \ map(filter(split(system(b:ledger_bin . ' -f ' . shellescape(expand(b:ledger_main)) . ' payees'), '\n'),
        \ "v:val =~? '" . strpart(a:argLead, 1) . "' && v:val !~? '^Warning: '"), '"@" . escape(v:val, " ")')
        \ :
        \ map(filter(split(system(b:ledger_bin . ' -f ' . shellescape(expand(b:ledger_main)) . ' accounts'), '\n'),
        \ "v:val =~? '" . a:argLead . "' && v:val !~? '^Warning: '"), 'escape(v:val, " ")')
endfunction

function! s:reconcile(file, account)
  " call inputsave()
  let l:amount = input('Target amount' . (empty(b:ledger_default_commodity) ? ': ' : ' (' . b:ledger_default_commodity . '): '))
  " call inputrestore()
  call ledger#reconcile(a:file, a:account, str2float(l:amount))
endfunction

" Commands
command! -buffer -nargs=? -complete=customlist,s:autocomplete_account_or_payee
      \ Balance call ledger#show_balance(b:ledger_main, <q-args>)

command! -buffer -nargs=+ -complete=customlist,s:autocomplete_account_or_payee
      \ Ledger call ledger#output(ledger#report(b:ledger_main, <q-args>))

command! -buffer -range LedgerAlign <line1>,<line2>call ledger#align_commodity()

command! -buffer LedgerAlignBuffer call ledger#align_commodity_buffer()

command! -buffer -nargs=1 -complete=customlist,s:autocomplete_account_or_payee
      \ Reconcile call <sid>reconcile(b:ledger_main, <q-args>)

command! -buffer -complete=customlist,s:autocomplete_account_or_payee -nargs=*
      \ Register call ledger#register(b:ledger_main, <q-args>)
