" speeddating.vim - Use CTRL-A/CTRL-X to increment dates, times, and more
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      20150124
" GetLatestVimScripts: 2120 1 :AutoInstall: speeddating.vim

" Initialization {{{1

if exists("g:loaded_speeddating") || &cp || v:version < 700
  finish
endif
let g:loaded_speeddating = 1

let s:cpo_save = &cpo
set cpo&vim

let g:speeddating_handlers = []

" }}}1
" Time Handler {{{1

function! s:add_format(master, count, bang) abort
  " Calls with neither argument nor count are for information,
  " and so should be handled immediately.
  " Call loadformats to cause autoloading to happen
  if a:master == "" && !a:count
    call speeddating#loadformats()
  endif

  if exists("g:speeddating_loaded_formats")
    " Autoloading already done pass on request immediately
    call speeddating#adddate(a:master,a:count,a:bang)
  else
    " Defer handling of format specifications until autoloading is done
    let g:speeddating_formats += [[a:master,a:count,a:bang]]
  endif
endfunction

command! -bar -bang -count=0 -nargs=? SpeedDatingFormat :call s:add_format(<q-args>,<count>,<bang>0)

" }}}1
" Maps {{{1

nnoremap <silent> <Plug>SpeedDatingUp   :<C-U>call speeddating#increment(v:count1)<CR>
nnoremap <silent> <Plug>SpeedDatingDown :<C-U>call speeddating#increment(-v:count1)<CR>
xnoremap <silent> <Plug>SpeedDatingUp   :<C-U>call speeddating#incrementvisual(v:count1)<CR>
xnoremap <silent> <Plug>SpeedDatingDown :<C-U>call speeddating#incrementvisual(-v:count1)<CR>
nnoremap <silent> <Plug>SpeedDatingNowLocal :<C-U>call speeddating#timestamp(0,v:count)<CR>
nnoremap <silent> <Plug>SpeedDatingNowUTC   :<C-U>call speeddating#timestamp(1,v:count)<CR>

for [s:key, s:type] in [['<C-A>', 'Up'], ['<C-X>', 'Down']]
  let s:rhs = maparg(s:key, 'n')
  if !empty(maparg('<Plug>SpeedDatingFallback'.s:type, 'n'))
    continue
  elseif s:rhs =~# '^$\|^gggH<C-O>G$\|^"+gP$\|^<Plug>SpeedDating'
    exe 'nnoremap <Plug>SpeedDatingFallback'.s:type s:key
  else
    exe 'nmap <Plug>SpeedDatingFallback'.s:type s:rhs
  endif
endfor

if !exists("g:speeddating_no_mappings") || !g:speeddating_no_mappings
  nmap  <C-A>     <Plug>SpeedDatingUp
  nmap  <C-X>     <Plug>SpeedDatingDown
  xmap  <C-A>     <Plug>SpeedDatingUp
  xmap  <C-X>     <Plug>SpeedDatingDown
  nmap d<C-A>     <Plug>SpeedDatingNowUTC
  nmap d<C-X>     <Plug>SpeedDatingNowLocal
endif

" }}}1
" Default Formats {{{1

if exists('g:speeddating_formats')
  finish
endif
let g:speeddating_formats = []
SpeedDatingFormat %i, %d %h %Y %H:%M:%S %z        " RFC822
SpeedDatingFormat %i, %h %d, %Y at %I:%M:%S%^P %z " mutt default date format
SpeedDatingFormat %a %b %_d %H:%M:%S %Z %Y        " default date(1) format
SpeedDatingFormat %a %h %-d %H:%M:%S %Y %z        " git
SpeedDatingFormat %h %_d %H:%M:%S                 " syslog
SpeedDatingFormat %Y-%m-%d%[ T_-]%H:%M:%S %z
SpeedDatingFormat %Y-%m-%d%[ T_-]%H:%M:%S%?[Z]    " SQL, etc.
SpeedDatingFormat %Y-%m-%d%[ T_-]%H:%M%z          " date -Im
SpeedDatingFormat %Y-%m-%d%[ T_-]%H:%M
SpeedDatingFormat %Y-%m-%d
SpeedDatingFormat %-I:%M:%S%?[ ]%^P
SpeedDatingFormat %-I:%M%?[ ]%^P
SpeedDatingFormat %-I%?[ ]%^P
SpeedDatingFormat %H:%M:%S,%k                     " SRT file
SpeedDatingFormat %H:%M:%S
SpeedDatingFormat %B %o, %Y
SpeedDatingFormat %d%[-/ ]%b%1%y
SpeedDatingFormat %d%[-/ ]%b%1%Y                " These three are common in the
SpeedDatingFormat %Y %b %d                      " 'Last Change:' headers of
SpeedDatingFormat %b %d, %Y                     " Vim runtime files
SpeedDatingFormat %^v
SpeedDatingFormat %v

" }}}1

let &cpo = s:cpo_save

" vim:set et sw=2 sts=2:
