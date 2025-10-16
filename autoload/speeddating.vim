" Location:     autoload/speeddating.vim

" Initialization {{{1

let s:cpo_save = &cpo
set cpo&vim

let s:install_dir = expand("<sfile>:p:h:h")

" }}}1
" Utility Functions {{{1

function! s:function(name) abort
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_'),''))
endfunction

" In Vim, -4 % 3 == -1.  Let's return 2 instead.
function! s:mod(a, b) abort
  if (a:a < 0 && a:b > 0 || a:a > 0 && a:b < 0) && a:a % a:b != 0
    return (a:a % a:b) + a:b
  else
    return a:a % a:b
  endif
endfunction

" In Vim, -4 / 3 == -1.  Let's return -2 instead.
function! s:div(a, b) abort
  if a:a < 0 && a:b > 0
    return (a:a-a:b+1)/a:b
  elseif a:a > 0 && a:b < 0
    return (a:a-a:b-1)/a:b
  else
    return a:a / a:b
  endif
endfunction

function! s:match(...) abort
  let b = call("match",a:000)
  let e = call("matchend",a:000)
  let s = call("matchlist",a:000)
  if s == []
    let s = ["","","","","","","","","",""]
  endif
  return [b,e] + s
endfunction

function! s:findatoffset(string, pattern, offset) abort
  let line = a:string
  let curpos = 0
  let offset = a:offset
  while strpart(line,offset,1) == " "
    let offset += 1
  endwhile
  let [start,end,string;caps] = s:match(line,a:pattern,curpos,0)
  while start >= 0
    if offset >= start && offset < end
      break
    endif
    let curpos = start + 1
    let [start,end,string;caps] = s:match(line,a:pattern,curpos,0)
  endwhile
  return [start,end,string] + caps
endfunction

function! s:findinline(pattern) abort
  return s:findatoffset(getline('.'),a:pattern,col('.')-1)
endfunction

function! s:replaceinline(start, end, new) abort
  let line = getline('.')
  let before_text = strpart(line,0,a:start)
  let after_text = strpart(line,a:end)
  " If this generates a warning it will be attached to an ugly backtrace.
  " No warning at all is preferable to that.
  silent call setline('.',before_text.a:new.after_text)
  call setpos("'[",[0,line('.'),strlen(before_text)+1,0])
  call setpos("']",[0,line('.'),a:start+strlen(a:new),0])
endfunction

" }}}1
" Normal Mode {{{1

function! speeddating#increment(increment) abort
  for handler in s:time_handlers + g:speeddating_handlers
    let pattern = type(handler.regexp) == type(function('tr')) ? handler.regexp() : handler.regexp
    let [start,end,string;caps] = s:findinline('\C'.pattern)
    if string != ""
      let [repl,offset] = handler.increment(string,col('.')-1-start,a:increment)
      if offset < 0
        let offset += strlen(repl) + 1
      endif
      if repl != ""
        call s:replaceinline(start,end,repl)
        call setpos('.',[0,line('.'),start+offset,0])
        silent! call repeat#set("\<Plug>SpeedDating" . (a:increment < 0 ? "Down" : "Up"),a:increment < 0 ? -a:increment : a:increment)
        return
      endif
    endif
  endfor
  if a:increment > 0
    exe "norm ". a:increment."\<Plug>SpeedDatingFallbackUp"
  else
    exe "norm ".-a:increment."\<Plug>SpeedDatingFallbackDown"
  endif
  silent! call repeat#set("\<Plug>SpeedDating" . (a:increment < 0 ? "Down" : "Up"),a:increment < 0 ? -a:increment : a:increment)
endfunction

" }}}1
" Visual Mode {{{1

function! s:setvirtcol(line, col) abort
  call setpos('.',[0,a:line,a:col,0])
  while virtcol('.') < a:col
    call setpos('.',[0,a:line,col('.')+1,0])
  endwhile
  while virtcol('.') > a:col
    call setpos('.',[0,a:line,col('.')-1,0])
  endwhile
  return col('.') + getpos('.')[3]
endfunction

function! s:chars(string) abort
  return strlen(substitute(a:string,'.','.','g'))
endfunction

function! s:incrementstring(string, offset, count) abort
  let repl = ""
  let offset = -1
  for handler in s:time_handlers + g:speeddating_handlers + s:visual_handlers
    let pattern = type(handler.regexp) == type(function('tr')) ? handler.regexp() : handler.regexp
    let [start,end,string;caps] = s:findatoffset(a:string,'\C'.pattern,a:offset)
    if string != ""
      let [repl,offset] = handler.increment(string,a:offset,a:count)
      if repl != ""
        break
      endif
    endif
  endfor
  if offset < 0
    let offset += strlen(repl) + 1
  endif

  if repl != ""
    let before_text = strpart(a:string,0,start)
    let change = s:chars(repl) - s:chars(string)
    if change < 0 && before_text !~ '\w$'
      let offset -= change
      let repl = repeat(' ',-change) . repl
    elseif change > 0 && before_text =~ ' $'
      let before_text = substitute(before_text,' \{1,'.change.'\}$','','')
      let before_text = substitute(before_text,'\w$','& ','')
      let start = strlen(before_text)
    endif
    let offset += start
    let repl = before_text.repl.strpart(a:string,end)
  endif
  return [repl,offset,start,end]
endfunction

function! speeddating#incrementvisual(count) abort
  let ve = &ve
  set virtualedit=all
  exe "norm! gv\<Esc>"
  if &selection ==# 'exclusive' && getpos('.') == getpos("'>")
    normal! h
  endif
  let vcol = virtcol('.')
  let lnum = line("'<")
  let lastrepl = ""
  call s:setvirtcol(lnum,vcol)
  call setpos("'[",[0,line("'<"),1,0])
  while lnum <= line("'>")
    call s:setvirtcol(lnum,vcol)
    let [repl,offset,start,end] = s:incrementstring(getline('.'),col('.')-1,a:count)
    if repl == "" && lastrepl != ""
      call setpos(".",[0,lnum-1,laststart,0])
      let start = s:setvirtcol(lnum,virtcol('.'))
      call setpos(".",[0,lnum-1,lastend,0])
      let end = s:setvirtcol(lnum,virtcol('.'))
      call s:setvirtcol(lnum,vcol)
      if strpart(getline('.'),start,end-start) =~ '^\s*$'
        let before_padded = start == end ? '' : printf("%-".start."s",strpart(getline('.'),0,start))
        let tweaked_line  = before_padded.strpart(lastrepl,laststart,lastend-laststart).strpart(getline('.'),end)
        let [repl,offset,start,end] = s:incrementstring(tweaked_line,col('.')-1,a:count*(lnum-lastlnum))
      endif
    elseif repl != ""
      let [lastrepl,laststart,lastend,lastlnum] = [repl,start,end,lnum]
    endif
    if repl != ""
      silent call setline('.',repl)
    endif
    let lnum += 1
  endwhile
  let &ve = ve
  call setpos("']",[0,line('.'),col('$'),0])
endfunction

" }}}1
" Visual Mode Handlers {{{1

let s:visual_handlers = []

function! s:numberincrement(string, offset, increment) abort
  let n = (a:string + a:increment)
  if a:string =~# '^0x.*[A-F]'
    return [printf("0x%X",n),-1]
  elseif a:string =~# '^0x'
    return [printf("0x%x",n),-1]
  elseif a:string =~# '^00*[^0]' && &nrformats =~# 'octal'
    return [printf("0%o",n),-1]
  elseif a:string =~# '^00*[^0]'
    return [printf("%0".strlen(a:string)."d",n),-1]
  else
    return [printf("%d",n),-1]
  endif
endfunction

let s:visual_handlers += [{'regexp': '-\=\<\%(0x\x\+\|\d\+\)\>', 'increment': s:function("s:numberincrement")}]

function! s:letterincrement(string, offset, increment) abort
  return [nr2char((char2nr(toupper(a:string)) - char2nr('A') + a:increment) % 26 + (a:string =~# '[A-Z]' ? char2nr('A') : char2nr('a'))),-1]
endfunction

let s:visual_handlers += [{'regexp': '\<[A-Za-z]\>', 'increment': s:function("s:letterincrement")}]

" }}}1
" Ordinals {{{1

function! s:ordinalize(number) abort
  let n = a:number
  let a = n < 0 ? -n : +n
  if a % 100 == 11 || a % 100 == 12 || a % 100 == 13
    return n."th"
  elseif a % 10 == 1
    return n."st"
  elseif a % 10 == 2
    return n."nd"
  elseif a % 10 == 3
    return n."rd"
  else
    return n."th"
  endif
endfunction

function! s:ordinalincrement(string, offset, increment) abort
  return [s:ordinalize(a:string+a:increment),-1]
endfunction

let g:speeddating_handlers += [{'regexp': '-\=\<\d\+\%(st\|nd\|rd\|th\)\>', 'increment': s:function("s:ordinalincrement")}]

" }}}1
" Roman Numerals {{{1

" Based on similar functions from VisIncr.vim

let s:a2r = [[1000, 'm'], [900, 'cm'], [500, 'd'], [400, 'cd'], [100, 'c'],
      \             [90 , 'xc'], [50 , 'l'], [40 , 'xl'], [10 , 'x'],
      \             [9  , 'ix'], [5  , 'v'], [4  , 'iv'], [1  , 'i']]

function! s:roman2arabic(roman) abort
  let roman  = tolower(a:roman)
  let sign   = 1
  let arabic = 0
  while roman != ''
    if roman =~ '^[-n]'
      let sign = -sign
    endif
    for [numbers,letters] in s:a2r
      if roman =~ '^'.letters
        let arabic += sign * numbers
        let roman = strpart(roman,strlen(letters)-1)
        break
      endif
    endfor
    let roman = strpart(roman,1)
  endwhile

  return arabic
endfunction

function! s:arabic2roman(arabic) abort
  if a:arabic <= 0
    let arabic = -a:arabic
    let roman = "n"
  else
    let arabic = a:arabic
    let roman = ""
  endif
  for [numbers, letters] in s:a2r
    let roman .= repeat(letters,arabic/numbers)
    let arabic = arabic % numbers
  endfor
  return roman
endfunction

" }}}1
" Time Helpers {{{1

function! s:ary2pat(array) abort
  return '\%('.join(a:array,'\|').'\)'
endfunction

function! s:initializetime(time) abort
  call extend(a:time,{'y': '','b':1,'d':0,'h':0,'m':0,'s':0,'o':0,'k':0},"keep")
  if get(a:time,'b','') !~ '^\d*$'
    let full = index(s:months_full ,a:time.b,0,1) + 1
    let engl = index(s:months_engl ,a:time.b,0,1) + 1
    let abbr = index(s:months_abbr ,a:time.b,0,1) + 1
    if full
      let a:time.b = full
    elseif engl
      let a:time.b = engl
    elseif abbr
      let a:time.b = abbr
    else
      let a:time.b = 1
    endif
  endif
  if has_key(a:time,'p')
    let a:time.h = a:time.h % 12
    if a:time.p ==? "PM"
      let a:time.h += 12
    endif
    call remove(a:time,"p")
  endif
  if a:time.y !~ '^\d*$'
    let a:time.y = s:roman2arabic(a:time.y)
  elseif a:time.y =~ '^-\=0..'
    let a:time.y = substitute(a:time.y,'0\+','','')
  elseif a:time.y < 38 && a:time.y >= 0 && ''.a:time.y != ''
    let a:time.y += 2000
  elseif a:time.y < 100 && a:time.y >= 38
    let a:time.y += 1900
  endif
  if has_key(a:time,'w')
    let full = index(s:days_full,a:time.w,0,1)
    let engl = index(s:days_engl,a:time.w,0,1)
    let abbr = index(s:days_abbr,a:time.w,0,1)
    let a:time.w = full >= 0 ? full : (engl >= 0 ? engl : (abbr >= 0 ? abbr : a:time.w))
    if a:time.d == 0
      let a:time.d = s:mod(a:time.w - s:jd(a:time.y, a:time.b, 1) - 1, 7) + 1
    elseif a:time.y == '' && a:time.b * a:time.d > 0
      let a:time.y = strftime("%Y")-2
      while s:mod(s:jd(a:time.y,a:time.b,a:time.d)+1,7) != a:time.w
        let a:time.y += 1
      endwhile
    endif
    call remove(a:time,'w')
  endif
  if a:time.d == 0
    let a:time.d = 1
  endif
  if ''.a:time.y == ''
    let a:time.y = 2000
  endif
  if a:time.o =~ '^[+-]\d\d:\=\d\d$'
    let a:time.o = (a:time.o[0]=="-" ? -1 : 1)*(a:time.o[1:2]*60+matchstr(a:time.o,'\d\d$'))
  elseif get(a:time,'z','') == g:speeddating_zone
    let a:time.o = s:offset
  elseif get(a:time,'z','') == g:speeddating_zone_dst
    let a:time.o = s:offset_dst
  endif
  return a:time
endfunction

" Julian day (always Gregorian calendar)
function! s:jd(year, mon, day) abort
  let y = a:year + 4800 - (a:mon <= 2)
  let m = a:mon + (a:mon <= 2 ? 9 : -3)
  let jul = a:day + (153*m+2)/5 + s:div(1461*y,4) - 32083
  return jul - s:div(y,100) + s:div(y,400) + 38
endfunction

function! s:gregorian(jd) abort
  let l = a:jd + 68569
  let n = s:div(4 * l, 146097)
  let l = l - s:div(146097 * n + 3, 4)
  let i = ( 4000 * ( l + 1 ) ) / 1461001
  let l = l - ( 1461 * i ) / 4 + 31
  let j = ( 80 * l ) / 2447
  let d = l - ( 2447 * j ) / 80
  let l = j / 11
  let m = j + 2 - ( 12 * l )
  let y = 100 * ( n - 49 ) + i + l
  return {'y':y,'b':m,'d':d}
endfunction

function! s:normalizetime(time) abort
  let a:time.y += s:div(a:time.b-1,12)
  let a:time.b = s:mod(a:time.b-1,12)+1
  let seconds = a:time.h * 3600 + a:time.m * 60 + a:time.s + s:div(a:time.k,1000)
  let a:time.k = s:mod(a:time.k,1000)
  let a:time.s = s:mod(seconds,60)
  let a:time.m = s:mod(s:div(seconds,60),60)
  let a:time.h = s:mod(s:div(seconds,3600),24)
  if seconds != 0 || a:time.b != 1 || a:time.d != 1
    let day = s:gregorian(s:jd(a:time.y,a:time.b,a:time.d)+s:div(seconds,86400))
    return extend(a:time,day)
  else
    return a:time
  endif
endfunction

function! s:applymodifer(number, modifier, width) abort
  if a:modifier == '-'
    return substitute(a:number,'^0*','','')
  elseif a:modifier == '_'
    return printf('%'.a:width.'d',a:number)
  elseif a:modifier == '^'
    return toupper(a:number)
  else
    return printf('%0'.a:width.'s',a:number)
  endif
endfunction

function! s:modyear(y) abort
  return printf('%02d',s:mod(a:y,100))
endfunction

function! s:strftime(pattern, time) abort
  if type(a:time) == type({})
    let time = s:normalizetime(copy(a:time))
  else
    let time = s:normalizetime(s:initializetime({'y':1970,'s':a:time}))
  endif
  let time.w = s:mod(s:jd(time.y,time.b,time.d)+1,7)
  let time.p = time.h
  let expanded = ""
  let remaining = a:pattern
  while remaining != ""
    if remaining =~ '^%'
      let modifier = matchstr(remaining,'%\zs[-_0^]\=\ze.')
      let specifier = matchstr(remaining,'%[-_0^]\=\zs.')
      let remaining = matchstr(remaining,'%[-_0^]\=.\zs.*')
      if specifier == '%'
        let expanded .= '%'
      elseif has_key(s:strftime_items,specifier)
        let item = s:strftime_items[specifier]
        let number = time[item[1]]
        if type(item[4]) == type([])
          let expanded .= s:applymodifer(item[4][number % len(item[4])],modifier,1)
        elseif type(item[4]) == type(function('tr'))
          let expanded .= s:applymodifer(call(item[4],[number]),modifier,1)
        else
          let expanded .= s:applymodifer(number,modifier,item[4])
        endif
      else
        let expanded .= '%'.modifier.specifier
      endif
    else
      let expanded .= matchstr(remaining,'[^%]*')
      let remaining = matchstr(remaining,'[^%]*\zs.*')
    endif
  endwhile
  return expanded
endfunction

function! s:localtime(...) abort
  let ts = a:0 ? a:1 : localtime() . '.0'
  let us = matchstr(ts,'\.\zs.\{0,6\}')
  let us .= repeat(0,6-strlen(us))
  let us = +matchstr(us,'[1-9].*')
  let time = {
        \ 'y': +strftime('%Y',ts),
        \ 'b': +strftime('%m',ts),
        \ 'd': +strftime('%d',ts),
        \ 'h': +strftime('%H',ts),
        \ 'm': +strftime('%M',ts),
        \ 's': +strftime('%S',ts),
        \ 'k': us / 1000}
  let jd = s:jd(time.y,time.b,time.d) - s:jd(1970,1,1)
  let real_ts = jd * 86400 + time.h * 3600 + time.m * 60 + time.s
  let time.o = (real_ts - ts) / 60
  return time
endfunction

function! s:formattz(offset) abort
  if a:offset < 0
    let offset = -a:offset
    let sign = "-"
  else
    let offset = a:offset
    let sign = "+"
  endif
  return printf("%s%02d%02d",sign,offset/60,offset%60)
endfunction

" }}}1
" Time Data {{{1

let s:offset     = s:localtime((  0+30*365)*86400).o
if !exists("g:speeddating_zone")
  let g:speeddating_zone = strftime("%Z",30*365*86400)
  if g:speeddating_zone == ""
    let g:speeddating_zone = get({-8:'PST',-7:'MST',-6:'CST',-5:'EST',0:'WET',1:'CET',2:'EET'},s:offset/60,"XST")
  endif
endif

let s:offset_dst = s:localtime((180+30*365)*86400).o
if !exists("g:speeddating_zone_dst")
  let g:speeddating_zone_dst = strftime("%Z",(180+30*365)*86400)
  if g:speeddating_zone_dst == ""
    if s:offset == s:offset_dst
      let g:speeddating_zone_dst = g:speeddating_zone
    else
      let g:speeddating_zone_dst = get({-7:'PDT',-6:'MDT',-5:'CDT',-4:'EDT',1:'WEST',2:'CEST',3:'EEST'},s:offset_dst/60,"XDT")
    endif
  endif
endif

let s:days_engl   =["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
let s:days_abbr   =map(range(86400*3+43200-s:offset*60,86400*12,86400),'strftime("%a",v:val)')[0:6]
let s:days_full   =map(range(86400*3+43200-s:offset*60,86400*12,86400),'strftime("%A",v:val)')[0:6]
let g:days_full = s:days_full

let s:months_engl =["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
let s:months_abbr =map(range(86400*2,86400*365,86400*31),'strftime("%b",v:val)')
let s:months_full =map(range(86400*2,86400*365,86400*31),'strftime("%B",v:val)')

let s:strftime_items = {
      \ "a": ['d','w',s:ary2pat(s:days_abbr),   'weekday (abbreviation)',s:days_abbr],
      \ "A": ['d','w',s:ary2pat(s:days_full),   'weekday (full name)',s:days_full],
      \ "i": ['d','w',s:ary2pat(s:days_engl),   'weekday (English abbr)',s:days_engl],
      \ "b": ['b','b',s:ary2pat(s:months_abbr), 'month (abbreviation)',[""]+s:months_abbr],
      \ "B": ['b','b',s:ary2pat(s:months_full), 'month (full name)',[""]+s:months_full],
      \ "h": ['b','b',s:ary2pat(s:months_engl), 'month (English abbr)',[""]+s:months_engl],
      \ "d": ['d','d','[ 0-3]\=\d', 'day   (01-31)',2],
      \ "H": ['h','h','[ 0-2]\=\d', 'hour  (00-23)',2],
      \ "I": ['h','h','[ 0-2]\=\d', 'hour  (01-12)',['12', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11']],
      \ "m": ['b','b','[ 0-1]\=\d', 'month (01-12)',2],
      \ "M": ['m','m','[ 0-5]\=\d', 'minutes',2],
      \ "o": ['d','d','[ 0-3]\=\d\%(st\|nd\|rd\|th\)','day  (1st-31st)',s:function("s:ordinalize")],
      \ "P": ['h','p','[ap]m', 'am/pm',repeat(['am'],12) + repeat(['pm'],12)],
      \ "S": ['s','s','[ 0-5]\=\d', 'seconds',2],
      \ "v": ['y','y','[ivxlcdmn]\+','year (roman numerals)',s:function("s:arabic2roman")],
      \ "y": ['y','y','\d\d','year  (00-99)',s:function("s:modyear")],
      \ "Y": ['y','y','-\=\d\d\d\=\d\=','year',4],
      \ "k": ['k','k','\d\d\d','milliseconds',3],
      \ "z": ['o','o','[+-]\d\d\d\d','timezone offset',s:function("s:formattz")],
      \ "Z": [' ','z','[A-Z]\{3,5}','timezone (incomplete)',3]}

" }}}1
" Time Handler {{{1

function! speeddating#timestamp(utc, count) abort
  for handler in s:time_handlers
    let [start,end,string;caps] = s:findinline('\C'.join(handler.groups,''))
    if string != ""
      let format = substitute(handler.strftime,'\\\([1-9]\)','\=caps[submatch(1)-1]','g')
      if a:utc || a:count
        let offset = (a:utc ? 1 : -1) * a:count * 15
        let time = s:initializetime({'y':1970,'s':localtime()+offset*60,'o':offset})
      else
        let time = s:localtime()
      endif
      if a:utc && !a:count
        let time.z = 'UTC'
      elseif time.o == s:offset
        let time.z = g:speeddating_zone
      elseif time.o == s:offset_dst
        let time.z = g:speeddating_zone_dst
      elseif time.o == 0
        let time.z = 'UTC'
      else
        let time.z = 'XXT'
      endif
      let newstring = s:strftime(format,time)
      call s:replaceinline(start,end,newstring)
      call setpos('.',[0,line('.'),start+strlen(newstring),0])
      silent! call repeat#set("\<Plug>SpeedDatingNow".(a:utc ? "UTC" : "Local"),a:count)
      return ""
    endif
  endfor
  let [start,end,string;caps] = s:findinline('-\=\<\d\+\>')
  if string != ""
    let newstring = localtime() + (a:utc ? 1 : -1) * a:count * 60*15
    call s:replaceinline(start,end,newstring)
    call setpos('.',[0,line('.'),start+strlen(newstring),0])
    silent! call repeat#set("\<Plug>SpeedDatingNow".(a:utc ? "UTC" : "Local"),a:count)
  endif
endfunction

function! s:dateincrement(string, offset, increment) dict abort
  let [start,end,string;caps] = s:match(a:string,'\C'.join(self.groups,''))
  let string = a:string
  let offset = a:offset
  let cursor_capture = 1
  let idx = 0
  while idx < len(self.groups)
    let partial_matchend = matchend(string,join(self.groups[0:idx],''))
    if partial_matchend > offset
      break
    endif
    let idx += 1
  endwhile
  while get(self.targets,idx,"") == " "
    let idx += 1
  endwhile
  while get(self.targets,idx," ") == " "
    let idx -= 1
  endwhile
  let partial_pattern = join(self.groups[0:idx],'')
  let char = self.targets[idx]
  let i = 0
  let time = {}
  for cap in caps
    if get(self.reader,i," ") !~ '^\s\=$'
      let time[self.reader[i]] = substitute(cap,'^\s*','','')
    endif
    let i += 1
  endfor
  call s:initializetime(time)
  let inner_offset = 0
  if char == 'o'
    let inner_offset = partial_matchend - offset - 1
    let factor = 15
    if inner_offset <= 0
      let inner_offset = 0
      let factor = 1
    elseif inner_offset > 1
      let factor = 60
      let inner_offset = 2
    endif
    let time.o += factor * a:increment
    let time.m += factor * a:increment
  elseif char == 'b'
    let time.b += a:increment
    let goal = time.y*12 + time.b
    call s:normalizetime(time)
    while time.y*12 + time.b > goal
      let time.d -= 1
      call s:normalizetime(time)
    endwhile
  else
    let time[char] += a:increment
  endif
  let format = substitute(self.strftime,'\\\([1-9]\)','\=caps[submatch(1)-1]','g')
  let time_string = s:strftime(format,time)
  return [time_string, matchend(time_string,partial_pattern)-inner_offset]
endfunction

function! s:timeregexp() dict abort
  return join(self.groups,'')
endfunction

function! s:createtimehandler(format) abort
  let pattern = '^\%(%?\=\[.\{-\}\]\|%[-_0^]\=.\|[^%]*\)'
  let regexp = ['\%(\<\|-\@=\)']
  let reader = []
  let targets = [' ']
  let template = ""
  let default = ""
  let remaining = substitute(a:format,'\C%\@<!%p','%^P','g')
  let group = 0
  let usergroups = []
  let userdefaults = []
  while remaining != ""
    let fragment  = matchstr(remaining,pattern)
    let remaining = matchstr(remaining,pattern.'\zs.*')
    if fragment =~ '^%\*\W'
      let suffix = '*'
      let fragment = '%' . strpart(fragment,2)
    elseif fragment =~ '^%?\W'
      let suffix = '\='
      let fragment = '%' . strpart(fragment,2)
    else
      let suffix = ''
    endif
    let targets += [' ']
    if fragment =~ '^%' && has_key(s:strftime_items,matchstr(fragment,'.$'))
      let item = s:strftime_items[matchstr(fragment,'.$')]
      let modifier = matchstr(fragment,'^%\zs.\ze.$')
      let targets[-1] = item[0]
      let reader += [item[1]]
      if modifier == '^'
        let pat = substitute(item[2],'\C\\\@<![[:lower:]]','\u&','g')
      elseif modifier == '0'
        let pat = substitute(item[2],' \|-\@<!\\=','','g')
      else
        let pat = item[2]
      endif
      let regexp += ['\('.pat.'\)']
      let group += 1
      let template .= fragment
      let default .= fragment
    elseif fragment =~ '^%\[.*\]$'
      let reader += [' ']
      let regexp += ['\('.matchstr(fragment,'\[.*').suffix.'\)']
      let group += 1
      let usergroups += [group]
      let template .= "\\".group
      if suffix == ""
        let default .= strpart(fragment,2,1)
        let userdefaults += [strpart(fragment,2,1)]
      else
        let userdefaults += [""]
      endif
    elseif fragment =~ '^%\d'
      let regexp += ["\\".usergroups[strpart(fragment,1)-1]]
      let template .= regexp[-1]
      let default .= userdefaults[strpart(fragment,1)-1]
    elseif fragment == '%*'
      if len(regexp) == 1
        let regexp = []
        let targets = []
      else
        let regexp += ['\(.*\)']
      endif
    else
      let regexp += [escape(fragment,'.*^$[\]~')]
      let template .= fragment
      let default .= fragment
    endif
  endwhile
  if regexp[-1] == '\(.*\)'
    call remove(regexp,-1)
    call remove(targets,-1)
  else
    let regexp += ['\>']
  endif
  return {'source': a:format, 'strftime': template, 'groups': regexp, 'regexp': s:function('s:timeregexp'), 'reader': reader, 'targets': targets, 'default': default, 'increment': s:function('s:dateincrement')}
endfunction

function! s:comparecase(i1, i2) abort
  if a:i1 ==? a:i2
    return a:i1 ==# a:i2 ? 0 : a:i1 ># a:i2 ? 1 : -1
  else
    return tolower(a:i1) > tolower(a:i2) ? 1 : -1
  endif
endfunction

function! speeddating#loadformats() abort
  if exists("g:speeddating_loaded_formats")
    return
  endif

  for fmt in g:speeddating_formats
    call speeddating#adddate( fmt[0], fmt[1], fmt[2] )
  endfor
  let g:speeddating_loaded_formats = 1
endfunction

function! speeddating#adddate(master, count, bang) abort
  if a:master == ""
    let time = s:initializetime({'y':1970,'s':localtime(),'z': 'UTC'})
    if a:bang && a:count
      silent! call remove(s:time_handlers,a:count - 1)
    elseif a:bang
      echo "SpeedDatingFormat             List defined formats"
      echo "SpeedDatingFormat!            This help"
      echo "SpeedDatingFormat %Y-%m-%d    Add a format"
      echo "1SpeedDatingFormat %Y-%m-%d   Add a format before first format"
      echo "SpeedDatingFormat! %Y-%m-%d   Remove a format"
      echo "1SpeedDatingFormat!           Remove first format"
      echo " "
      echo "Expansions:"
      for key in sort(keys(s:strftime_items),s:function("s:comparecase"))
        echo printf("%2s     %-25s %s",'%'.key,s:strftime_items[key][3],s:strftime('%'.key,time))
      endfor
      echo '%0x    %x with mandatory leading zeros'
      echo '%_x    %x with spaces rather than leading zeros'
      echo '%-x    %x with no leading spaces or zeros'
      echo '%^x    %x in uppercase'
      echo '%*     at beginning/end, surpress \</\> respectively'
      echo '%[..]  any one character         \([..]\)'
      echo '%?[..] up to one character       \([..]\=\)'
      echo '%1     character from first collection match \1'
      echo " "
      echo "Examples:"
      echo 'SpeedDatingFormat %m%[/-]%d%1%Y    " American 12/25/2007'
      echo 'SpeedDatingFormat %d%[/-]%m%1%Y    " European 25/12/2007'
      echo " "
      echo "Define formats in ".s:install_dir."/after/plugin/speeddating.vim"
    elseif a:count
      echo get(s:time_handlers,a:count-1,{'source':''}).source
    else
      let i = 0
      for handler in s:time_handlers
        let i += 1
        echo printf("%3d %-32s %-32s",i,handler.source,s:strftime(handler.default,time))
      endfor
    endif
  elseif a:bang
    call filter(s:time_handlers,'v:val.source != a:master')
  else
    let handler = s:createtimehandler(a:master)
    if a:count
      call insert(s:time_handlers,handler,a:count - 1)
    else
      let s:time_handlers += [handler]
    endif
  endif
endfunction

if !exists('s:time_handlers')
  let s:time_handlers = []
  call speeddating#loadformats()
endif

" }}}1

let &cpo = s:cpo_save

" vim:set et sw=2 sts=2:
