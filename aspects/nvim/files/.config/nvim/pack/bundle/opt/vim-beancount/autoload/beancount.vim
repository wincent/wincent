let s:using_python3 = has('python3')

" Equivalent to python's startswith
" Matches based on user's ignorecase preference
function! s:startswith(string, prefix) abort
    return strpart(a:string, 0, strlen(a:prefix)) == a:prefix
endfunction

" Align currency on decimal point.
function! beancount#align_commodity(line1, line2) abort
    " Save cursor position to adjust it if necessary.
    let l:cursor_col = col('.')
    let l:cursor_line = line('.')

    " Increment at start of loop, because of continue statements.
    let l:current_line = a:line1 - 1
    while l:current_line < a:line2
        let l:current_line += 1
        let l:line = getline(l:current_line)
        " This matches an account name followed by a space in one of the two
        " following cases:
        "  - A posting line, i.e., the line starts with indentation followed
        "    by an optional flag and the account.
        "  - A balance directive, i.e., the line starts with a date followed
        "    by the 'balance' keyword and the account.
        "  - A price directive, i.e., the line starts with a date followed by
        "    the 'price' keyword and a currency.
        let l:end_account = matchend(l:line, '\v' .
            \ '^[\-/[:digit:]]+\s+balance\s+([A-Z][A-Za-z0-9\-]+)(:[A-Z0-9][A-Za-z0-9\-]*)+ ' .
            \ '|^[\-/[:digit:]]+\s+price\s+\S+ ' .
            \ '|^\s+([!&#?%PSTCURM]\s+)?([A-Z][A-Za-z0-9\-]+)(:[A-Z0-9][A-Za-z0-9\-]*)+ '
            \ )
        if l:end_account < 0
            continue
        endif

        " Where does the number begin?
        let l:begin_number = matchend(l:line, '^ *', l:end_account)

        " Look for a minus sign and a number (possibly containing commas) and
        " align on the next column.
        let l:separator = matchend(l:line, '^\v([-+])?[,[:digit:]]+', l:begin_number) + 1
        if l:separator < 0 | continue | endif
        let l:has_spaces = l:begin_number - l:end_account
        let l:need_spaces = g:beancount_separator_col - l:separator + l:has_spaces
        if l:need_spaces < 0 | continue | endif
        call setline(l:current_line, l:line[0 : l:end_account - 1] . repeat(' ', l:need_spaces) . l:line[ l:begin_number : -1])
        if l:current_line == l:cursor_line && l:cursor_col >= l:end_account
            " Adjust cursor position for continuity.
            call cursor(0, l:cursor_col + l:need_spaces - l:has_spaces)
        endif
    endwhile
endfunction

function! s:count_expression(text, expression) abort
    return len(split(a:text, a:expression, 1)) - 1
endfunction

function! s:sort_accounts_by_depth(name1, name2) abort
    let l:depth1 = s:count_expression(a:name1, ':')
    let l:depth2 = s:count_expression(a:name2, ':')
    return l:depth1 == l:depth2 ? 0 : l:depth1 > l:depth2 ? 1 : -1
endfunction

let s:directives = ['open', 'close', 'commodity', 'txn', 'balance', 'pad', 'note', 'document', 'price', 'event', 'query', 'custom']

" ------------------------------
" Completion functions
" ------------------------------
function! beancount#complete(findstart, base) abort
    if a:findstart
        let l:col = searchpos('\s', 'bn', line('.'))[1]
        if l:col == 0
            return -1
        else
            return l:col
        endif
    endif

    let l:partial_line = strpart(getline('.'), 0, getpos('.')[2]-1)
    " Match directive types
    if l:partial_line =~# '^\d\d\d\d\(-\|/\)\d\d\1\d\d $'
        return beancount#complete_basic(s:directives, a:base, '')
    endif

    " If we are using python3, now is a good time to load everything
    call beancount#load_everything()

    " Split out the first character (for cases where we don't want to match the
    " leading character: ", #, etc)
    let l:first = strpart(a:base, 0, 1)
    let l:rest = strpart(a:base, 1)

    if l:partial_line =~# '^\d\d\d\d\(-\|/\)\d\d\1\d\d event $' && l:first ==# '"'
        return beancount#complete_basic(b:beancount_events, l:rest, '"')
    endif

    let l:two_tokens = searchpos('\S\+\s', 'bn', line('.'))[1]
    let l:prev_token = strpart(getline('.'), l:two_tokens, getpos('.')[2] - l:two_tokens)
    " Match curriences if previous token is number
    if l:prev_token =~# '^\d\+\([\.,]\d\+\)*'
        call beancount#load_currencies()
        return beancount#complete_basic(b:beancount_currencies, a:base, '')
    endif

    if l:first ==# '#'
        call beancount#load_tags()
        return beancount#complete_basic(b:beancount_tags, l:rest, '#')
    elseif l:first ==# '^'
        call beancount#load_links()
        return beancount#complete_basic(b:beancount_links, l:rest, '^')
    elseif l:first ==# '"'
        call beancount#load_payees()
        return beancount#complete_basic(b:beancount_payees, l:rest, '"')
    else
        call beancount#load_accounts()
        return beancount#complete_account(a:base)
    endif
endfunction

function! beancount#get_root() abort
    if exists('b:beancount_root')
        return b:beancount_root
    endif
    return expand('%')
endfunction

function! beancount#load_everything() abort
    if s:using_python3 && !exists('b:beancount_loaded')
        let l:root = beancount#get_root()
python3 << EOF
import vim
from beancount import loader
from beancount.core import data

accounts = set()
currencies = set()
events = set()
links = set()
payees = set()
tags = set()

entries, errors, options_map = loader.load_file(vim.eval('l:root'))
for index, entry in enumerate(entries):
    if isinstance(entry, data.Open):
        accounts.add(entry.account)
        if entry.currencies:
            currencies.update(entry.currencies)
    elif isinstance(entry, data.Commodity):
        currencies.add(entry.currency)
    elif isinstance(entry, data.Event):
        events.add(entry.type)
    elif isinstance(entry, data.Transaction):
        if entry.tags:
            tags.update(entry.tags)
        if entry.links:
            links.update(entry.links)
        if entry.payee:
            payees.add(entry.payee)

vim.command('let b:beancount_accounts = [{}]'.format(','.join(repr(x) for x in sorted(accounts))))
vim.command('let b:beancount_currencies = [{}]'.format(','.join(repr(x) for x in sorted(currencies))))
vim.command('let b:beancount_events = [{}]'.format(','.join(repr(x) for x in sorted(events))))
vim.command('let b:beancount_links = [{}]'.format(','.join(repr(x) for x in sorted(links))))
vim.command('let b:beancount_payees = [{}]'.format(','.join(repr(x) for x in sorted(payees))))
vim.command('let b:beancount_tags = [{}]'.format(','.join(repr(x) for x in sorted(tags))))
vim.command('let b:beancount_loaded = v:true'.format(','.join(repr(x) for x in sorted(tags))))
EOF
    endif
endfunction

function! beancount#load_accounts() abort
    if !s:using_python3 && !exists('b:beancount_accounts')
        let l:root = beancount#get_root()
        let b:beancount_accounts = beancount#query_single(l:root, 'select distinct account;')
    endif
endfunction

function! beancount#load_tags() abort
    if !s:using_python3 && !exists('b:beancount_tags')
        let l:root = beancount#get_root()
        let b:beancount_tags = beancount#query_single(l:root, 'select distinct tags;')
    endif
endfunction

function! beancount#load_links() abort
    if !s:using_python3 && !exists('b:beancount_links')
        let l:root = beancount#get_root()
        let b:beancount_links = beancount#query_single(l:root, 'select distinct links;')
    endif
endfunction

function! beancount#load_currencies() abort
    if !s:using_python3 && !exists('b:beancount_currencies')
        let l:root = beancount#get_root()
        let b:beancount_currencies = beancount#query_single(l:root, 'select distinct currency;')
    endif
endfunction

function! beancount#load_payees() abort
    if !s:using_python3 && !exists('b:beancount_payees')
        let l:root = beancount#get_root()
        let b:beancount_payees = beancount#query_single(l:root, 'select distinct payee;')
    endif
endfunction

" General completion function
function! beancount#complete_basic(input, base, prefix) abort
    let l:matches = filter(copy(a:input), 's:startswith(v:val, a:base)')

    return map(l:matches, 'a:prefix . v:val')
endfunction

" Complete account name.
function! beancount#complete_account(base) abort
    if g:beancount_account_completion ==? 'chunks'
        let l:pattern = '^\V' . substitute(a:base, ':', '\\[^:]\\*:', 'g') . '\[^:]\*'
    else
        let l:pattern = '^\V\.\*' . substitute(a:base, ':', '\\.\\*:\\.\\*', 'g') . '\.\*'
    endif

    let l:matches = []
    let l:index = -1
    while 1
        let l:index = match(b:beancount_accounts, l:pattern, l:index + 1)
        if l:index == -1 | break | endif
        call add(l:matches, matchstr(b:beancount_accounts[l:index], l:pattern))
    endwhile

    if g:beancount_detailed_first
        let l:matches = reverse(sort(l:matches, 's:sort_accounts_by_depth'))
    endif

    return l:matches
endfunction

function! beancount#query_single(root_file, query) abort
python << EOF
import vim
import subprocess
import os

# We intentionally want to ignore stderr so it doesn't mess up our query processing
output = subprocess.check_output(['bean-query', vim.eval('a:root_file'), vim.eval('a:query')], stderr=open(os.devnull, 'w')).split('\n')
output = output[2:]

result_list = [y for y in (x.strip() for x in output) if y]

vim.command('return [{}]'.format(','.join(repr(x) for x in sorted(result_list))))
EOF
endfunction

" Call bean-doctor on the current line and dump output into a scratch buffer
function! beancount#get_context() abort
    let l:context = system('bean-doctor context ' . expand('%') . ' ' . line('.'))
    botright new
    setlocal buftype=nofile bufhidden=hide noswapfile
    call append(0, split(l:context, '\v\n'))
    normal! gg
endfunction
