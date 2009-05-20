"=============================================================================
" File:                plugin/fuzzyfinder.vim
" Author:              Takeshi NISHIDA <ns9tks@DELETE-ME.gmail.com>
" Version:             2.21.0, for Vim 7.1
" Licence:             MIT Licence
" GetLatestVimScripts: 1984 1 :AutoInstall: fuzzyfinder.vim
"
" See doc/fuzzyfinder.txt for details.
"
"=============================================================================
" LOAD GUARD: {{{1
if exists('g:loaded_fuzzyfinder') || v:version < 701
  finish
endif
let g:loaded_fuzzyfinder = 022100 " Version xx.xx.xx

" }}}1
"=============================================================================
" FUNCTIONS: LIST ------------------------------------------------------- {{{1

"
function! s:Unique(in)
  let sorted = sort(a:in)
  if len(sorted) < 2
    return sorted
  endif
  let last = remove(sorted, 0)
  let result = [last]
  for item in sorted
    if item != last
      call add(result, item)
      let last = item
    endif
  endfor
  return result
endfunction

" [ [0], [1,2], [3] ] -> [ 0, 1, 2, 3 ]
function! s:Concat(in)
  let result = []
  for l in a:in
    let result += l
  endfor
  return result
endfunction

" copy + filter + limit
function! s:FilterEx(in, expr, limit)
  if a:limit <= 0
    return filter(copy(a:in), a:expr)
  endif
  let result = []
  let stride = a:limit * 3 / 2 " x1.5
  for i in range(0, len(a:in) - 1, stride)
    let result += filter(a:in[i : i + stride - 1], a:expr)
    if len(result) >= a:limit
      return remove(result, 0, a:limit - 1)
    endif
  endfor
  return result
endfunction

" 
function! s:FilterMatching(items, key, pattern, index, limit)
  return s:FilterEx(a:items, 'v:val[''' . a:key . '''] =~ ' . string(a:pattern) . ' || v:val.index == ' . a:index, a:limit)
endfunction

"
function! s:MapToSetSerialIndex(in, offset)
  for i in range(len(a:in))
    let a:in[i].index = i + a:offset
  endfor
  return a:in
endfunction

"
function! s:UpdateMruList(mrulist, new_item, max_item, excluded)
  let result = copy(a:mrulist)
  let result = filter(result,'v:val.word != a:new_item.word')
  let result = insert(result, a:new_item)
  let result = filter(result, 'v:val.word !~ a:excluded')
  return result[0 : a:max_item - 1]
endfunction

" FUNCTIONS: STRING ----------------------------------------------------- {{{1

" truncates a:str and add a:mark if a length of a:str is more than a:len
function! s:TruncateHead(str, len)
  if a:len >= len(a:str)
    return a:str
  elseif a:len <= len(s:ABBR_TRUNCATION_MARK)
    return s:ABBR_TRUNCATION_MARK
  endif
  return s:ABBR_TRUNCATION_MARK . a:str[-a:len + len(s:ABBR_TRUNCATION_MARK):]
endfunction

" truncates a:str and add a:mark if a length of a:str is more than a:len
function! s:TruncateTail(str, len)
  if a:len >= len(a:str)
    return a:str
  elseif a:len <= len(s:ABBR_TRUNCATION_MARK)
    return s:ABBR_TRUNCATION_MARK
  endif
  return a:str[:a:len - 1 + len(s:ABBR_TRUNCATION_MARK)] . s:ABBR_TRUNCATION_MARK
endfunction

" takes suffix numer. if no digits, returns -1
function! s:SuffixNumber(str)
  let s = matchstr(a:str, '\d\+$')
  return (len(s) ? str2nr(s) : -1)
endfunction

"
function! s:ConvertWildcardToRegexp(expr)
  let re = escape(a:expr, '\')
  for [pat, sub] in [ [ '*', '\\.\\*' ], [ '?', '\\.' ], [ '[', '\\[' ], ]
    let re = substitute(re, pat, sub, 'g')
  endfor
  return '\V' . re
endfunction

" "foo/bar/hoge" -> { head: "foo/bar/", tail: "hoge" }
function! s:SplitPath(path)
  let dir = matchstr(a:path, '^.*[/\\]')
  return  {
        \   'head' : dir,
        \   'tail' : a:path[strlen(dir):]
        \ }
endfunction

"
function! s:EscapeFilename(fn)
  return escape(a:fn, " \t\n*?[{`$%#'\"|!<")
endfunction

" "foo/.../bar/...hoge" -> "foo/.../bar/../../hoge"
function! s:ExpandTailDotSequenceToParentDir(base)
  return substitute(a:base, '^\(.*[/\\]\)\?\zs\.\(\.\+\)\ze[^/\\]*$',
        \           '\=repeat(".." . s:PATH_SEPARATOR, len(submatch(2)))', '')
endfunction

"
function! s:ExistsPrompt(line, prompt)
  return  strlen(a:line) >= strlen(a:prompt) && a:line[:strlen(a:prompt) -1] ==# a:prompt
endfunction

"
function! s:RemovePrompt(line, prompt)
  return a:line[(s:ExistsPrompt(a:line, a:prompt) ? strlen(a:prompt) : 0):]
endfunction

"
function! s:RestorePrompt(line, prompt)
  let i = 0
  while i < len(a:prompt) && i < len(a:line) && a:prompt[i] ==# a:line[i]
    let i += 1
  endwhile
  return a:prompt . a:line[i : ]
endfunction

" FUNCTIONS: COMPLETION ITEM: ------------------------------------------- {{{1

" returns [v(1), v(2), ..., v(n) ] , v(i) < v(i+1) , v(1) > v(n)/2
function! s:MakeAscendingValues(n, total)
  let values = range(a:n, a:n * 2 - 1)
  let sum = 0
  for val in values
    let sum += val
  endfor
  return map(values, 'v:val * a:total / sum')
endfunction

" a range of return value is [0, s:MATCHING_RATE_BASE]
function! s:EvaluateMatchingRate(word, base)
  let rate = 0
  let scores = s:MakeAscendingValues(len(a:word), s:MATCHING_RATE_BASE)
  let matched = 0
  let skip_penalty = 1
  let i_base = 0
  for i_word in range(len(a:word))
    if i_base >= len(a:base)
      let skip_penalty = skip_penalty * 2
      break
    elseif a:word[i_word] == a:base[i_base]
      let rate += scores[i_word]
      let matched = 1
      let i_base += 1
    elseif matched
      let skip_penalty = skip_penalty * 2
      let matched = 0
    endif
  endfor
  return rate / skip_penalty
endfunction

" 
function! s:EvaluateLearningRank(word, stats)
  for i in range(len(a:stats))
    if a:stats[i].word ==# a:word
      return i
    endif
  endfor
  return len(a:stats)
endfunction


" FUNCTIONS: COMMANDLINE ------------------------------------------------ {{{1

"
function! s:EchoWithHl(msg, hl)
  execute "echohl " . a:hl
  echo a:msg
  echohl None
endfunction

"
function! s:InputHl(prompt, text, hl)
  execute "echohl " . a:hl
  let s = input(a:prompt, a:text)
  echohl None
  return s
endfunction

" FUNCTIONS: FUZZYFIDNER WINDOW ----------------------------------------- {{{1

"
function! s:HighlightPrompt(prompt, highlight)
  syntax clear
  execute printf('syntax match %s /^\V%s/', a:highlight, escape(a:prompt, '\'))
endfunction

"
function! s:HighlightError()
  syntax clear
  syntax match Error  /^.*$/
endfunction

" FUNCTIONS: TAG -------------------------------------------------------- {{{1

"
function! s:GetTagList(tagfile)
  let result = map(readfile(a:tagfile), 'matchstr(v:val, ''^[^!\t][^\t]*'')')
  return filter(result, 'v:val =~ ''\S''')
endfunction

"
function! s:GetTaggedFileList(tagfile)
  execute 'cd ' . fnamemodify(a:tagfile, ':h')
  let result = map(readfile(a:tagfile), 'fnamemodify(matchstr(v:val, ''^[^!\t][^\t]*\t\zs[^\t]\+''), '':p:~'')')
  cd -
  return filter(result, 'v:val =~ ''[^/\\ ]$''')
endfunction

"
function! s:GetCurrentTagFiles()
  return sort(filter(map(tagfiles(), 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
endfunction

" FUNCTIONS: MISC ------------------------------------------------------- {{{1

"
function! s:IsAvailableMode(mode)
  return exists('a:mode.mode_available') && a:mode.mode_available
endfunction

"
function! s:GetAvailableModes()
  return filter(values(g:FuzzyFinderMode), 's:IsAvailableMode(v:val)')
endfunction

"
function! s:GetSortedSwitchableModes()
  let modes = filter(items(g:FuzzyFinderMode), 's:IsAvailableMode(v:val[1]) && v:val[1].switch_order >= 0')
  let modes = map(modes, 'extend(v:val[1], { "ranks" : [v:val[1].switch_order, v:val[0]] })')
  return sort(modes, 's:CompareRanks')
endfunction

"
function! s:GetSidPrefix()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

"
function! s:OnCmdCR()
  for m in s:GetAvailableModes()
    call m.extend_options()
    call m.on_command_pre(getcmdtype() . getcmdline())
  endfor
  " lets last entry become the newest in the history
  call histadd(getcmdtype(), getcmdline())
  " this is not mapped again (:help recursive_mapping)
  return "\<CR>"
endfunction

"
function! s:ExpandAbbrevMap(base, abbrev_map)
  let result = [a:base]
  " expand
  for [pattern, sub_list] in items(a:abbrev_map)
    let exprs = result
    let result = []
    for expr in exprs
      let result += map(copy(sub_list), 'substitute(expr, pattern, v:val, "g")')
    endfor
  endfor
  return s:Unique(result)
endfunction

"
function! s:EnumExpandedDirsEntries(dir, excluded)
  " Substitutes "\" because on Windows, "**\" doesn't include ".\",
  " but "**/" include "./". I don't know why.
  let dirs = split(expand(substitute(a:dir, '\', '/', 'g')), "\n")
  let entries = s:Concat(map(copy(dirs), 'split(glob(v:val . ".*"), "\n") + ' .
        \                                'split(glob(v:val . "*" ), "\n")'))
  call filter(entries, 'v:val !~ ''\v(^|[/\\])\.\.?$''')
  call map(entries, 'extend(s:SplitPath(v:val), { "suffix" : (isdirectory(v:val) ? s:PATH_SEPARATOR : "") })')
  if len(a:excluded)
    call filter(entries, '(v:val.head . v:val.tail . v:val.suffix) !~ a:excluded')
  endif
  return entries
endfunction

"
function! s:GetBufIndicator(buf_nr)
  if !getbufvar(a:buf_nr, '&modifiable')
    return '[-]'
  elseif getbufvar(a:buf_nr, '&modified')
    return '[+]'
  elseif getbufvar(a:buf_nr, '&readonly')
    return '[R]'
  else
    return '   '
  endif
endfunction

"
function! s:ModifyWordAsFilename(item, mods)
  let a:item.word = fnamemodify(a:item.word, a:mods)
  return a:item
endfunction

"
function! s:SetFormattedTimeToMenu(item, format)
  let a:item.menu = strftime(a:format, a:item.time)
  return a:item
endfunction

"
function! s:SetRanks(item, eval_word, eval_base, stats)
  "let eval_word = (a:is_path ? s:SplitPath(matchstr(a:item.word, '^.*[^/\\]')).tail : a:item.word)
  "let eval_base = (a:is_path ? s:SplitPath(a:base).tail : a:base)
  let rank_perfect = (a:eval_word == a:eval_base ? 0 : 1)
  if a:eval_word == a:eval_base
    let rank_perfect = 1
    let rank_matching = 0
  else
    let rank_perfect = 2
    let rank_matching = -s:EvaluateMatchingRate(a:eval_word, a:eval_base)
  endif
  let a:item.ranks = [ rank_perfect, s:EvaluateLearningRank(a:item.word, a:stats), rank_matching, a:item.index ]
  return a:item
endfunction

"
function! s:SetFormattedWordToAbbr(item, max_menu_width)
  let abbr_prefix = (exists('a:item.abbr_prefix') ? a:item.abbr_prefix : '')
  let a:item.abbr = s:TruncateTail(printf('%3d: ', a:item.index) . abbr_prefix . a:item.word, a:max_menu_width)
  return a:item
endfunction

"
function! s:SetDataToAbbrForFile(item)
  let a:item.abbr = s:SplitPath(a:item.word)
  let a:item.abbr.prefix = printf('%3d: ', a:item.index) . (exists('a:item.abbr_prefix') ? a:item.abbr_prefix : '')
  return a:item
endfunction

"
function! s:FormatAbbrForFile(item, max_menu_width, len_drop)
  let len_head = len(v:val.abbr.head) - a:len_drop
  let a:item.abbr = v:val.abbr.prefix . s:TruncateHead(v:val.abbr.head, len_head) . v:val.abbr.tail
  let a:item.abbr = s:TruncateTail(a:item.abbr, a:max_menu_width)
  return a:item
endfunction

"
function! s:MapToSetFormattedWordToAbbrForFile(items, max_menu_width)
  let result = map(a:items, 's:SetDataToAbbrForFile(v:val)')
  let len_drop = max(map(copy(result), 'len(v:val.abbr.prefix . v:val.abbr.head . v:val.abbr.tail)')) - a:max_menu_width
  return map(a:items, 's:FormatAbbrForFile(v:val, a:max_menu_width, len_drop)')
endfunction

"
function! s:CompareTimeDescending(i1, i2)
  return a:i1.time == a:i2.time ? 0 : a:i1.time > a:i2.time ? -1 : +1
endfunction

"
function! s:CompareRanks(i1, i2)
  if exists('a:i1.ranks') && exists('a:i2.ranks')
    for i in range(min([len(a:i1.ranks), len(a:i2.ranks)]))
      if     a:i1.ranks[i] > a:i2.ranks[i]
        return +1
      elseif a:i1.ranks[i] < a:i2.ranks[i]
        return -1
      endif
    endfor
  endif
  return 0
endfunction

"
function! s:GetLinePattern(lnum)
  return '\C\V\^' . escape(getline(a:lnum), '\') . '\$'
endfunction

" opens a:path and jumps to the line matching to a:pattern from a:lnum within
" a:range. if not found, jumps to a:lnum.
function! s:JumpToBookmark(path, mode, pattern, lnum, range, reuse)
  call s:OpenFile(a:path, a:mode, a:reuse)
  let ln = a:lnum
  for i in range(0, a:range)
    if a:lnum + i <= line('$') && getline(a:lnum + i) =~ a:pattern
      let ln += i
      break
    elseif a:lnum - i >= 1 && getline(a:lnum - i) =~ a:pattern
      let ln -= i
      break
    endif
  endfor
  call cursor(ln, 0)
  normal! zvzz
endfunction

" returns 0 if the buffer is not found.
function! s:MoveToWindowOfBufferInCurrentTabPage(buf_nr)
  if count(tabpagebuflist(), a:buf_nr) == 0
    return 0
  endif
  execute bufwinnr(a:buf_nr) . 'wincmd w'
  return 1
endfunction

" returns 0 if the buffer is not found.
function! s:MoveToOtherTabPageOpeningBuffer(buf_nr)
  for tab_nr in range(1, tabpagenr('$'))
    if tab_nr != tabpagenr() && count(tabpagebuflist(tab_nr), a:buf_nr) > 0
      execute 'tabnext ' . tab_nr
      return 1
    endif
  endfor
  return 0
endfunction

" returns 0 if the buffer is not found.
function! s:MoveToWindowOfBufferInOtherTabPage(buf_nr)
  if !s:MoveToOtherTabPageOpeningBuffer(a:buf_nr)
    return 0
  endif
  return s:MoveToWindowOfBufferInCurrentTabPage(a:buf_nr)
endfunction

"
function! s:OpenBuffer(buf_nr, mode, reuse)
  if a:reuse && ((a:mode == s:OPEN_MODE_SPLIT  && s:MoveToWindowOfBufferInCurrentTabPage(a:buf_nr)) ||
        \        (a:mode == s:OPEN_MODE_VSPLIT && s:MoveToWindowOfBufferInCurrentTabPage(a:buf_nr)) ||
        \        (a:mode == s:OPEN_MODE_TAB    && s:MoveToWindowOfBufferInOtherTabPage  (a:buf_nr)))
    return
  endif
  execute printf({
        \   s:OPEN_MODE_CURRENT : ':%sbuffer'           ,
        \   s:OPEN_MODE_SPLIT   : ':%ssbuffer'          ,
        \   s:OPEN_MODE_VSPLIT  : ':vertical :%ssbuffer',
        \   s:OPEN_MODE_TAB     : ':tab :%ssbuffer'     ,
        \ }[a:mode], a:buf_nr)
endfunction

"
function! s:OpenFile(path, mode, reuse)
  let buf_nr = bufnr('^' . a:path . '$')
  if buf_nr > -1
    call s:OpenBuffer(buf_nr, a:mode, a:reuse)
  else
    execute {
          \   s:OPEN_MODE_CURRENT : ':edit '   ,
          \   s:OPEN_MODE_SPLIT   : ':split '  ,
          \   s:OPEN_MODE_VSPLIT  : ':vsplit ' ,
          \   s:OPEN_MODE_TAB     : ':tabedit ',
          \ }[a:mode] . s:EscapeFilename(a:path)
  endif
endfunction

"
function s:OpenTag(tag, mode)
  execute {
        \   s:OPEN_MODE_CURRENT : ':tjump '           ,
        \   s:OPEN_MODE_SPLIT   : ':stjump '          ,
        \   s:OPEN_MODE_VSPLIT  : ':vertical :stjump ',
        \   s:OPEN_MODE_TAB     : ':tab :stjump '     ,
        \ }[a:mode] . a:tag
endfunction

"
function! s:SelectedText() " by id:ka-nacht
  let [visual_p, pos] = [mode() =~# "[vV\<C-v>]", getpos('.')]
  let [r_, r_t] = [@@, getregtype('"')]
  let [r0, r0t] = [@0, getregtype('0')]
  if visual_p
    execute "normal! \<Esc>"
  endif
  silent normal! gvy
  let [_, _t] = [@@, getregtype('"')]
  call setreg('"', r_, r_t)
  call setreg('0', r0, r0t)
  if visual_p
    normal! gv
  else
    call setpos('.', pos)
  endif
  return _
endfunction

" }}}1
"=============================================================================
" OBJECT: g:FuzzyFinderMode.Base ---------------------------------------- {{{1
let g:FuzzyFinderMode = { 'Base' : {} }

"
function! g:FuzzyFinderMode.Base.launch(initial_pattern, partial_matching)
  " initializes this object
  call self.extend_options()
  let self.partial_matching = a:partial_matching
  let self.prev_bufnr = bufnr('%')
  let self.last_col = -1
  call s:InfoFileManager.load()
  if !s:IsAvailableMode(self)
    echo 'This mode is not available: ' . self.to_str()
    return
  endif
  call self.on_mode_enter_pre()
  call s:WindowManager.activate(self.make_complete_func('CompleteFunc'))
  call s:OptionManager.set('completeopt', 'menuone')
  call s:OptionManager.set('ignorecase', self.ignore_case)
  " local autocommands
  augroup FuzzyfinderLocal
    autocmd!
    execute 'autocmd CursorMovedI <buffer>        call ' . self.to_str('on_cursor_moved_i()')
    execute 'autocmd InsertLeave  <buffer> nested call ' . self.to_str('on_insert_leave()'  )
  augroup END
  " local mapping
  for [lhs, rhs] in [
        \   [ self.key_open       , self.to_str('on_cr(' . s:OPEN_MODE_CURRENT . ', 0)') ],
        \   [ self.key_open_split , self.to_str('on_cr(' . s:OPEN_MODE_SPLIT   . ', 0)') ],
        \   [ self.key_open_vsplit, self.to_str('on_cr(' . s:OPEN_MODE_VSPLIT  . ', 0)') ],
        \   [ self.key_open_tab   , self.to_str('on_cr(' . s:OPEN_MODE_TAB     . ', 0)') ],
        \   [ '<BS>'              , self.to_str('on_bs()'                              ) ],
        \   [ '<C-h>'             , self.to_str('on_bs()'                              ) ],
        \   [ self.key_next_mode  , self.to_str('on_switch_mode(+1)'                   ) ],
        \   [ self.key_prev_mode  , self.to_str('on_switch_mode(-1)'                   ) ],
        \   [ self.key_ignore_case, self.to_str('on_switch_ignore_case()'              ) ],
        \ ]
    " hacks to be able to use feedkeys().
    execute printf('inoremap <buffer> <silent> %s <C-r>=%s ? "" : ""<CR>', lhs, rhs)
  endfor
  " Starts Insert mode and makes CursorMovedI event now. Command prompt is
  " needed to forces a completion menu to update every typing.
  call setline(1, self.prompt . a:initial_pattern)
  call self.on_mode_enter_post()
  call feedkeys("A", 'n') " startinsert! does not work in InsertLeave handler
endfunction

"
function! g:FuzzyFinderMode.Base.on_cursor_moved_i()
  if !s:ExistsPrompt(getline('.'), self.prompt)
    call setline('.', s:RestorePrompt(getline('.'), self.prompt))
    call feedkeys("\<End>", 'n')
  elseif col('.') <= len(self.prompt)
    " if the cursor is moved before command prompt
    call feedkeys(repeat("\<Right>", len(self.prompt) - col('.') + 1), 'n')
  elseif col('.') > strlen(getline('.')) && col('.') != self.last_col
    " if the cursor is placed on the end of the line and has been actually moved.
    let self.last_col = col('.')
    let self.last_base = s:RemovePrompt(getline('.'), self.prompt)
    call feedkeys("\<C-x>\<C-o>", 'n')
  endif
endfunction

"
function! g:FuzzyFinderMode.Base.on_insert_leave()
  let last_pattern = s:RemovePrompt(getline('.'), self.prompt)
  call s:OptionManager.restore_all()
  call s:WindowManager.deactivate()
  let reserved = exists('s:reserved_command')
  if reserved
    call self.on_open(s:reserved_command[0], s:reserved_command[1])
    unlet s:reserved_command
  endif
  call self.on_mode_leave_post(reserved)
  call self.empty_cache_if_existed(0)
  " switchs to next mode, or finishes fuzzyfinder.
  if exists('s:reserved_switch_mode')
    let m = self.next_mode(s:reserved_switch_mode < 0)
    call m.launch(last_pattern, self.partial_matching)
    unlet s:reserved_switch_mode
  endif
endfunction

"
function! g:FuzzyFinderMode.Base.on_buf_enter()
endfunction

"
function! g:FuzzyFinderMode.Base.on_buf_write_post()
endfunction

"
function! g:FuzzyFinderMode.Base.on_command_pre(cmd)
endfunction

"
function! g:FuzzyFinderMode.Base.on_cr(index, dir_check)
  if pumvisible()
    call feedkeys(printf("\<C-y>\<C-r>=%s(%d, 1) ? '' : ''\<CR>", self.to_str('on_cr'), a:index), 'n')
    return
  endif
  if !empty(self.last_base)
    call self.add_stat(self.last_base, s:RemovePrompt(getline('.'), self.prompt))
  endif
  if a:dir_check && getline('.') =~ '[/\\]$'
    return
  endif
  let s:reserved_command = [s:RemovePrompt(getline('.'), self.prompt), a:index]
  call feedkeys("\<Esc>", 'n') " stopinsert behavior is strange...
endfunction

"
function! g:FuzzyFinderMode.Base.on_bs()
  let bs_count = 1
  if self.smart_bs && col('.') > 2 && getline('.')[col('.') - 2] =~ '[/\\]'
    let bs_count = len(matchstr(getline('.')[:col('.') - 3], '[^/\\]*$')) + 1
  endif
  call feedkeys((pumvisible() ? "\<C-e>" : "") . repeat("\<BS>", bs_count), 'n')
endfunction

" Before entering Fuzzyfinder buffer. This function should return in a short time.
function! g:FuzzyFinderMode.Base.on_mode_enter_pre()
endfunction

" After entering Fuzzyfinder buffer.
function! g:FuzzyFinderMode.Base.on_mode_enter_post()
endfunction

" After leaving Fuzzyfinder buffer.
function! g:FuzzyFinderMode.Base.on_mode_leave_post(opened)
endfunction

"
function! g:FuzzyFinderMode.Base.on_open(expr, mode)
  call s:OpenFile(a:expr, a:mode, self.reuse_window)
endfunction

"
function! g:FuzzyFinderMode.Base.on_switch_mode(next_prev)
  let s:reserved_switch_mode = a:next_prev
  call feedkeys("\<Esc>", 'n') " stopinsert behavior is strange...
endfunction

"
function! g:FuzzyFinderMode.Base.on_switch_ignore_case()
  let &ignorecase = !&ignorecase
  echo "ignorecase = " . &ignorecase
  let self.last_col = -1
  call self.on_cursor_moved_i()
endfunction

" export mode-specific information as string list
function! g:FuzzyFinderMode.Base.serialize_info()
  let header_data  = self.to_key() . ".data\t"
  let header_stats = self.to_key() . ".stats\t"
  return  map(copy(self.data ), 'header_data  . string(v:val)') +
        \ map(copy(self.stats), 'header_stats . string(v:val)')
endfunction

" import mode-specific information from string list
function! g:FuzzyFinderMode.Base.deserialize_info(lines)
  let header_data  = self.to_key() . ".data\t"
  let header_stats = self.to_key() . ".stats\t"
  let self.data  = map(filter(copy(a:lines), 'v:val[: len(header_data ) - 1] ==# header_data '),
        \              'eval(v:val[len(header_data ) :])')
  let self.stats = map(filter(copy(a:lines), 'v:val[: len(header_stats) - 1] ==# header_stats'),
        \              'eval(v:val[len(header_stats) :])')
  call filter(self.stats, '!empty(v:val.base)') " NOTE: remove this line someday
endfunction

"
function! g:FuzzyFinderMode.Base.add_stat(base, word)
  call s:InfoFileManager.load()
  let stat = { 'base' : a:base, 'word' : a:word }
  call filter(self.stats, 'v:val !=# stat')
  call insert(self.stats, stat)
  let self.stats = self.stats[0 : self.learning_limit - 1]
  call s:InfoFileManager.save()
endfunction

"
function! g:FuzzyFinderMode.Base.complete(findstart, base)
  if a:findstart
    return 0
  elseif  !s:ExistsPrompt(a:base, self.prompt) || len(s:RemovePrompt(a:base, self.prompt)) < self.min_length
    return []
  endif
  call s:HighlightPrompt(self.prompt, self.prompt_highlight)
  " FIXME: ExpandAbbrevMap duplicates index
  let result = []
  for expanded_base in s:ExpandAbbrevMap(s:RemovePrompt(a:base, self.prompt), self.abbrev_map)
    let result += self.on_complete(expanded_base)
  endfor
  call sort(result, 's:CompareRanks')
  if empty(result) || len(result) >= self.enumerating_limit
    call s:HighlightError()
  endif
  if !empty(result)
    call feedkeys("\<C-p>\<Down>", 'n')
  endif
  return result
endfunction

" This function is set to 'completefunc' which doesn't accept dictionary-functions.
function! g:FuzzyFinderMode.Base.make_complete_func(name)
  execute printf("function! s:%s(findstart, base)\n" .
        \        "  return %s.complete(a:findstart, a:base)\n" .
        \        "endfunction", a:name, self.to_str())
  return s:GetSidPrefix() . a:name
endfunction

" fuzzy  : 'str' -> {'base':'str', 'wi':'*s*t*r*', 're':'\V\.\*s\.\*t\.\*r\.\*'}
" partial: 'str' -> {'base':'str', 'wi':'*str*', 're':'\V\.\*str\.\*'}
function! g:FuzzyFinderMode.Base.make_pattern(base)
  if self.partial_matching
    let wi = (a:base !~ '^[*?]'  ? '*' : '') . a:base .
          \  (a:base =~ '[^*?]$' ? '*' : '')
    let re = s:ConvertWildcardToRegexp(wi)
    return { 'base': a:base, 'wi':wi, 're': re }
  else
    let wi = ''
    for char in split(a:base, '\zs')
      if wi !~ '[*?]$' && char !~ '[*?]'
        let wi .= '*'. char
      else
        let wi .= char
      endif
    endfor
    if wi !~ '[*?]$'
      let wi .= '*'
    endif
    let re = s:ConvertWildcardToRegexp(wi)
    if self.migemo_support && a:base !~ '[^\x01-\x7e]'
      let re .= '\|\m.*' . substitute(migemo(a:base), '\\_s\*', '.*', 'g') . '.*'
    endif
    return { 'base': a:base, 'wi':wi, 're': re }
  endif
endfunction

"
function! g:FuzzyFinderMode.Base.get_filtered_stats(base)
  return filter(copy(self.stats), 'v:val.base ==# a:base')
endfunction

"
function! g:FuzzyFinderMode.Base.empty_cache_if_existed(force)
  if exists('self.cache') && (a:force || !exists('self.lasting_cache') || !self.lasting_cache)
    unlet self.cache
  endif
endfunction

"
function! g:FuzzyFinderMode.Base.to_key()
  return filter(keys(g:FuzzyFinderMode), 'g:FuzzyFinderMode[v:val] is self')[0]
endfunction

" returns 'g:FuzzyFinderMode.{key}{.argument}'
function! g:FuzzyFinderMode.Base.to_str(...)
  return 'g:FuzzyFinderMode.' . self.to_key() . (a:0 > 0 ? '.' . a:1 : '')
endfunction

" takes in g:FuzzyFinderOptions
function! g:FuzzyFinderMode.Base.extend_options()
  call extend(self, g:FuzzyFinderOptions.Base, 'force')
  call extend(self, g:FuzzyFinderOptions[self.to_key()], 'force')
endfunction

"
function! g:FuzzyFinderMode.Base.next_mode(rev)
  let modes = (a:rev ? s:GetSortedSwitchableModes() : reverse(s:GetSortedSwitchableModes()))
  let m_last = modes[-1]
  for m in modes
    if m is self
      break
    endif
    let m_last = m
  endfor
  return m_last
  " vim crashed using map()
endfunction

" OBJECT: g:FuzzyFinderMode.Buffer -------------------------------------- {{{1
let g:FuzzyFinderMode.Buffer = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.Buffer.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let base_tail = s:SplitPath(a:base).tail
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, base_tail, stats)')
endfunction

"
function! g:FuzzyFinderMode.Buffer.on_open(expr, mode)
  " filter the selected item to get the buffer number for handling unnamed buffer
  call filter(self.items, 'v:val.word ==# a:expr')
  if !empty(self.items)
    call s:OpenBuffer(self.items[0].buf_nr, a:mode, self.reuse_window)
  endif
endfunction

"
function! g:FuzzyFinderMode.Buffer.on_mode_enter_post()
  let self.items = map(filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != self.prev_bufnr'),
        \              'self.make_item(v:val)')
  if self.mru_order
    call s:MapToSetSerialIndex(sort(self.items, 's:CompareTimeDescending'), 1)
  endif
  let self.items = s:MapToSetFormattedWordToAbbrForFile(self.items, self.max_menu_width)
endfunction

"
function! g:FuzzyFinderMode.Buffer.on_buf_enter()
  call self.update_buf_times()
endfunction

"
function! g:FuzzyFinderMode.Buffer.on_buf_write_post()
  call self.update_buf_times()
endfunction

"
function! g:FuzzyFinderMode.Buffer.update_buf_times()
  call extend(self, { 'buf_times' : {} }, 'keep')
  let self.buf_times[bufnr('%')] = localtime()
endfunction

"
function! g:FuzzyFinderMode.Buffer.make_item(nr)
  let path = (empty(bufname(a:nr)) ? '[No Name]' : fnamemodify(bufname(a:nr), ':~:.'))
  let time = (exists('self.buf_times[a:nr]') ? self.buf_times[a:nr] : 0)
  return  {
        \   'index'       : a:nr,
        \   'buf_nr'      : a:nr,
        \   'word'        : path,
        \   'abbr_prefix' : s:GetBufIndicator(a:nr) . ' ',
        \   'menu'        : strftime(self.time_format, time),
        \   'time'        : time,
        \ }
endfunction

"  'edit'/'split'/'vsplit'/'tabedit'
function! g:FuzzyFinderMode.Buffer.jump_to(item, cmd_open)
endfunction

" OBJECT: g:FuzzyFinderMode.File ---------------------------------------- {{{1
let g:FuzzyFinderMode.File = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.File.on_complete(base)
  let base = s:ExpandTailDotSequenceToParentDir(a:base)
  let patterns = map(s:SplitPath(base), 'self.make_pattern(v:val)')
  let stats = self.get_filtered_stats(a:base)
  let result = self.cached_glob(patterns.head.base, patterns.tail.re, self.excluded_path, s:SuffixNumber(patterns.tail.base), self.enumerating_limit)
  let result = filter(result, 'bufnr("^" . v:val.word . "$") != self.prev_bufnr')
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, patterns.tail.base, stats)')
endfunction

"
function! g:FuzzyFinderMode.File.cached_glob(dir, file, excluded, index, limit)
  let key = fnamemodify(a:dir, ':p')
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]')
    echo 'Caching file list...'
    let self.cache[key] = s:EnumExpandedDirsEntries(key, a:excluded)
    call s:MapToSetSerialIndex(self.cache[key], 1)
  endif
  echo 'Filtering file list...'
  let result = s:FilterMatching(self.cache[key], 'tail', a:file, a:index, a:limit)
  call map(result, '{ "index" : v:val.index, "word" : (v:val.head == key ? a:dir : v:val.head) . v:val.tail . v:val.suffix }') 
  return s:MapToSetFormattedWordToAbbrForFile(result, self.max_menu_width)
endfunction

" OBJECT: g:FuzzyFinderMode.Dir ----------------------------------------- {{{1
let g:FuzzyFinderMode.Dir = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.Dir.on_complete(base)
  let base = s:ExpandTailDotSequenceToParentDir(a:base)
  let patterns = map(s:SplitPath(base), 'self.make_pattern(v:val)')
  let stats = self.get_filtered_stats(a:base)
  let result = self.cached_glob_dir(patterns.head.base, patterns.tail.re, self.excluded_path, s:SuffixNumber(patterns.tail.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, patterns.tail.base, stats)')
endfunction

"
function! g:FuzzyFinderMode.Dir.on_open(expr, mode)
  execute ':cd ' . s:EscapeFilename(a:expr)
endfunction

"
function! g:FuzzyFinderMode.Dir.cached_glob_dir(dir, file, excluded, index, limit)
  let key = fnamemodify(a:dir, ':p')
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]')
    echo 'Caching file list...'
    let self.cache[key] = filter(s:EnumExpandedDirsEntries(key, a:excluded), 'len(v:val.suffix)')
    if isdirectory(key . '.' . s:PATH_SEPARATOR)
      call insert(self.cache[key], { 'head' : key, 'tail' : '.' , 'suffix' : '' })
    endif
    call s:MapToSetSerialIndex(self.cache[key], 1)
  endif
  echo 'Filtering file list...'
  let result = s:FilterMatching(self.cache[key], 'tail', a:file, a:index, a:limit)
  call map(result, '{ "index" : v:val.index, "word" : (v:val.head == key ? a:dir : v:val.head) . v:val.tail . v:val.suffix }') 
  return s:MapToSetFormattedWordToAbbrForFile(result, self.max_menu_width)
endfunction

" OBJECT: g:FuzzyFinderMode.MruFile ------------------------------------- {{{1
let g:FuzzyFinderMode.MruFile = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.MruFile.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let base_tail = s:SplitPath(a:base).tail
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, base_tail, stats)')
endfunction

"
function! g:FuzzyFinderMode.MruFile.on_mode_enter_post()
  let self.items = copy(self.data)
  let self.items = map(self.items, 'self.format_item_using_cache(v:val)')
  let self.items = filter(self.items, '!empty(v:val) && bufnr("^" . v:val.word . "$") != self.prev_bufnr')
  let self.items = s:MapToSetSerialIndex(self.items, 1)
  let self.items = s:MapToSetFormattedWordToAbbrForFile(self.items, self.max_menu_width)
endfunction

"
function! g:FuzzyFinderMode.MruFile.on_buf_enter()
  call self.update_info()
endfunction

"
function! g:FuzzyFinderMode.MruFile.on_buf_write_post()
  call self.update_info()
endfunction

"
function! g:FuzzyFinderMode.MruFile.update_info()
  if !empty(&buftype) || expand('%') !~ '\S'
    return
  endif
  call s:InfoFileManager.load()
  let self.data = s:UpdateMruList(self.data, { 'word' : expand('%:p'), 'time' : localtime() },
        \                         self.max_item, self.excluded_path)
  call s:InfoFileManager.save()
  call self.remove_item_from_cache(expand('%:p'))
endfunction

" returns empty value if invalid item
function! g:FuzzyFinderMode.MruFile.format_item_using_cache(item)
  call extend(self, { 'cache' : {} }, 'keep')
  if a:item.word !~ '\S'
    return {}
  endif
  if !exists('self.cache[a:item.word]')
    let self.cache[a:item.word] =
          \ (filereadable(a:item.word)
          \  ? s:ModifyWordAsFilename(s:SetFormattedTimeToMenu(copy(a:item), self.time_format), ':p:~')
          \  : {})
  endif
  return self.cache[a:item.word]
endfunction

"
function! g:FuzzyFinderMode.MruFile.remove_item_from_cache(word)
  if !exists('self.cache')
    return
  endif
  for items in values(self.cache)
    if exists('items[a:word]')
      unlet items[a:word]
    endif
  endfor
endfunction

" OBJECT: g:FuzzyFinderMode.MruCmd -------------------------------------- {{{1
let g:FuzzyFinderMode.MruCmd = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.MruCmd.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, v:val.word, a:base, stats)')
endfunction

"
function! g:FuzzyFinderMode.MruCmd.on_open(expr, mode)
  call self.update_info(a:expr)
  call histadd(a:expr[0], a:expr[1:])
  call feedkeys(a:expr . "\<CR>", 'n')
endfunction

"
function! g:FuzzyFinderMode.MruCmd.on_mode_enter_post()
  let self.items = copy(self.data)
  let self.items = map(self.items, 's:SetFormattedTimeToMenu(v:val, self.time_format)')
  let self.items = s:MapToSetSerialIndex(self.items, 1)
  let self.items = map(self.items, 's:SetFormattedWordToAbbr(v:val, self.max_menu_width)')
endfunction

"
function! g:FuzzyFinderMode.MruCmd.on_command_pre(cmd)
  if getcmdtype() =~ '^[:/?]'
    call self.update_info(a:cmd)
  endif
endfunction

"
function! g:FuzzyFinderMode.MruCmd.update_info(cmd)
  call s:InfoFileManager.load()
  let self.data = s:UpdateMruList(self.data, { 'word' : a:cmd, 'time' : localtime() },
        \                         self.max_item, self.excluded_command)
  call s:InfoFileManager.save()
endfunction

" OBJECT: g:FuzzyFinderMode.Bookmark ------------------------------------ {{{1
let g:FuzzyFinderMode.Bookmark = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.Bookmark.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, v:val.word, a:base, stats)')
endfunction

"
function! g:FuzzyFinderMode.Bookmark.on_open(expr, mode)
  call filter(self.items, 'v:val.word ==# a:expr')
  if empty(self.items)
    return ''
  endif
  call s:JumpToBookmark(self.items[0].path, a:mode, self.items[0].pattern, self.items[0].lnum, self.searching_range,
        \               self.reuse_window)
endfunction

"
function! g:FuzzyFinderMode.Bookmark.on_mode_enter_post()
  let self.items = copy(self.data)
  let self.items = map(self.items, 's:SetFormattedTimeToMenu(v:val, self.time_format)')
  let self.items = s:MapToSetSerialIndex(self.items, 1)
  let self.items = map(self.items, 's:SetFormattedWordToAbbr(v:val, self.max_menu_width)')
endfunction

"
function! g:FuzzyFinderMode.Bookmark.bookmark_here(word)
  if !empty(&buftype) || expand('%') !~ '\S'
    call s:EchoWithHl('Can''t bookmark this buffer.', 'WarningMsg')
    return
  endif
  let item = {
        \   'word' : (a:word =~ '\S' ? substitute(a:word, '\n', ' ', 'g')
        \                            : pathshorten(expand('%:p:~')) . '|' . line('.') . '| ' . getline('.')),
        \   'path' : expand('%:p'),
        \   'lnum' : line('.'),
        \   'pattern' : s:GetLinePattern(line('.')),
        \   'time' : localtime(),
        \ }
  let item.word = s:InputHl('Bookmark as:', item.word, 'Question')
  if item.word !~ '\S'
    call s:EchoWithHl('Canceled', 'WarningMsg')
    return
  endif
  call s:InfoFileManager.load()
  call insert(self.data, item)
  call s:InfoFileManager.save()
endfunction

" OBJECT: g:FuzzyFinderMode.Tag ----------------------------------------- {{{1
let g:FuzzyFinderMode.Tag = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.Tag.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let stats = self.get_filtered_stats(a:base)
  let result = self.find_tag(patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, v:val.word, a:base, stats)')
endfunction

"
function! g:FuzzyFinderMode.Tag.on_open(expr, mode)
  call s:OpenTag(a:expr, a:mode)
endfunction

"
function! g:FuzzyFinderMode.Tag.on_mode_enter_pre()
  let self.tag_files = s:GetCurrentTagFiles()
endfunction

"
function! g:FuzzyFinderMode.Tag.find_tag(pattern, index, limit)
  if !len(self.tag_files)
    return []
  endif
  let key = join(self.tag_files, "\n")
  " cache not created or tags file updated? 
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]') || max(map(copy(self.tag_files), 'getftime(v:val) >= self.cache[key].time'))
    echo 'Caching tag list...'
    let items = s:Unique(s:Concat(map(copy(self.tag_files), 's:GetTagList(v:val)')))
    let items = s:MapToSetSerialIndex(map(items, '{ "word" : v:val }'), 1)
    let self.cache[key] = { 'time'  : localtime(), 'items' : items }
  endif
  echo 'Filtering tag list...'
  let result = s:FilterMatching(self.cache[key].items, 'word', a:pattern, a:index, a:limit)
  return map(result, 's:SetFormattedWordToAbbr(v:val, self.max_menu_width)')
endfunction

" OBJECT: g:FuzzyFinderMode.TaggedFile ---------------------------------- {{{1
let g:FuzzyFinderMode.TaggedFile = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.TaggedFile.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let base_tail = s:SplitPath(a:base).tail
  let stats = self.get_filtered_stats(a:base)
  echo 'Making tagged file list...'
  let result = self.find_tagged_file(patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, base_tail, stats)')
endfunction

"
function! g:FuzzyFinderMode.TaggedFile.on_mode_enter_pre()
  let self.tag_files = s:GetCurrentTagFiles()
endfunction

"
function! g:FuzzyFinderMode.TaggedFile.find_tagged_file(pattern, index, limit)
  if !len(self.tag_files)
    return []
  endif
  let key = join(self.tag_files, "\n")
  " cache not created or tags file updated? 
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]') || max(map(copy(self.tag_files), 'getftime(v:val) >= self.cache[key].time'))
    echo 'Caching tagged-file list...'
    let items = s:Unique(s:Concat(map(copy(self.tag_files), 's:GetTaggedFileList(v:val)')))
    let items = s:MapToSetSerialIndex(map(items, '{ "word" : v:val }'), 1)
    let self.cache[key] = { 'time'  : localtime(), 'items' : items }
  endif
  echo 'Filtering tagged-file list...'
  call map(self.cache[key].items, 's:ModifyWordAsFilename(v:val, '':.'')')
  let result = s:FilterMatching(self.cache[key].items, 'word', a:pattern, a:index, a:limit)
  return s:MapToSetFormattedWordToAbbrForFile(result, self.max_menu_width)
endfunction

" OBJECT: g:FuzzyFinderMode.CallbackFile -------------------------------- {{{1
let g:FuzzyFinderMode.CallbackFile = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.CallbackFile.launch_callbacker(initial_pattern, partial_matching, callback_func)
  let self.callback_func = a:callback_func
  call.self.launch(a:initial_pattern, a:partial_matching)
endfunction

"
function! g:FuzzyFinderMode.CallbackFile.on_complete(base)
  let base = s:ExpandTailDotSequenceToParentDir(a:base)
  let patterns = map(s:SplitPath(base), 'self.make_pattern(v:val)')
  let stats = self.get_filtered_stats(a:base)
  let result = self.cached_glob(patterns.head.base, patterns.tail.re, self.excluded_path, s:SuffixNumber(patterns.tail.base), self.enumerating_limit)
  let result = filter(result, 'bufnr("^" . v:val.word . "$") != self.prev_bufnr')
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, patterns.tail.base, stats)')
endfunction

"
function! g:FuzzyFinderMode.CallbackFile.on_open(expr, mode)
  call eval(printf('%s(%s, %d)', self.callback_func, string(a:expr), a:mode))
endfunction

"
function! g:FuzzyFinderMode.CallbackFile.on_switch_mode(next_prev)
  " mode switching is unavailable
endfunction

"
function! g:FuzzyFinderMode.CallbackFile.on_mode_leave_post(opened)
  if !a:opened
    call eval(printf('%s()', self.callback_func))
  endif
endfunction

"
function! g:FuzzyFinderMode.CallbackFile.cached_glob(dir, file, excluded, index, limit)
  let key = fnamemodify(a:dir, ':p')
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]')
    echo 'Caching file list...'
    let self.cache[key] = s:EnumExpandedDirsEntries(key, a:excluded)
    if isdirectory(key . '.' . s:PATH_SEPARATOR)
      call insert(self.cache[key], { 'head' : key, 'tail' : '.' , 'suffix' : '' })
    endif
    call s:MapToSetSerialIndex(self.cache[key], 1)
  endif
  echo 'Filtering file list...'
  let result = s:FilterMatching(self.cache[key], 'tail', a:file, a:index, a:limit)
  call map(result, '{ "index" : v:val.index, "word" : (v:val.head == key ? a:dir : v:val.head) . v:val.tail . v:val.suffix }') 
  return s:MapToSetFormattedWordToAbbrForFile(result, self.max_menu_width)
endfunction

" OBJECT: g:FuzzyFinderMode.CallbackItem -------------------------------- {{{1
let g:FuzzyFinderMode.CallbackItem = copy(g:FuzzyFinderMode.Base)

"
function! g:FuzzyFinderMode.CallbackItem.launch_callbacker(initial_pattern, partial_matching, callback_func, items, for_file)
  let self.callback_func = a:callback_func
  let self.items = s:MapToSetSerialIndex(map(copy(a:items), '{ "word" : v:val }'), 1)
  let self.on_complete = (a:for_file ? self.on_complete_file : self.on_complete_nonfile)
  call.self.launch(a:initial_pattern, a:partial_matching)
endfunction

"
function! g:FuzzyFinderMode.CallbackItem.on_complete_file(base)
  let patterns = self.make_pattern(a:base)
  let base_tail = s:SplitPath(a:base).tail
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, s:SplitPath(matchstr(v:val.word, ''^.*[^/\\]'')).tail, base_tail, stats)')
endfunction

"
function! g:FuzzyFinderMode.CallbackItem.on_complete_nonfile(base)
  let patterns = self.make_pattern(a:base)
  let stats = self.get_filtered_stats(a:base)
  let result = s:FilterMatching(self.items, 'word', patterns.re, s:SuffixNumber(patterns.base), self.enumerating_limit)
  return map(result, 's:SetRanks(v:val, v:val.word, a:base, stats)')
endfunction

"
function! g:FuzzyFinderMode.CallbackItem.on_open(expr, mode)
  call eval(printf('%s(%s, %d)', self.callback_func, string(a:expr), a:mode))
endfunction

"
function! g:FuzzyFinderMode.CallbackItem.on_switch_mode(next_prev)
  " mode switching is unavailable
endfunction

"
function! g:FuzzyFinderMode.CallbackItem.on_mode_leave_post(opened)
  if !a:opened
    call eval(printf('%s()', self.callback_func))
  endif
endfunction

" OBJECT: s:OptionManager ----------------------------------------------- {{{1
" sets or restores temporary options
let s:OptionManager = { 'originals' : {} }

"
function! s:OptionManager.set(name, value)
  call extend(self.originals, { a:name : eval('&' . a:name) }, 'keep')
  execute printf('let &%s = a:value', a:name)
endfunction

"
function! s:OptionManager.restore_all()
  for [name, value] in items(self.originals)
    execute printf('let &%s = value', name)
  endfor
  let self.originals = {}
endfunction

" OBJECT: s:WindowManager ----------------------------------------------- {{{1
" manages buffer/window for fuzzyfinder
let s:WindowManager = { 'buf_nr' : -1 }

"
function! s:WindowManager.activate(complete_func)
  let cwd = getcwd()
  let self.buf_nr = s:Open1LineBuffer(self.buf_nr, '[Fuzzyfinder]')
  call s:SetLocalOptionsForFuzzyfinder(cwd, a:complete_func)
  redraw " for 'lazyredraw'
  if exists(':AutoComplPopLock') | execute ':AutoComplPopLock' | endif
endfunction

"
function! s:WindowManager.deactivate()
  if exists(':AutoComplPopUnlock') | execute ':AutoComplPopUnlock' | endif
  " must close after returning to previous window
  wincmd j
  execute self.buf_nr . 'bdelete'
endfunction

" Returns a buffer number. Creates new buffer if a:buf_nr is a invalid number
function! s:Open1LineBuffer(buf_nr, buf_name)
  if !bufexists(a:buf_nr)
    leftabove 1new
    execute printf('file `=%s`', string(a:buf_name))
  elseif bufwinnr(a:buf_nr) == -1
    leftabove 1split
    execute a:buf_nr . 'buffer'
    delete _
  elseif bufwinnr(a:buf_nr) != bufwinnr('%')
    execute bufwinnr(a:buf_nr) . 'wincmd w'
  endif
  return bufnr('%')
endfunction

"
function! s:SetLocalOptionsForFuzzyfinder(cwd, complete_func)
  " countermeasure against auto-cd script
  execute ':lcd ' . escape(a:cwd, ' ')
  setlocal filetype=fuzzyfinder
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  setlocal nocursorline   " for highlighting
  setlocal nocursorcolumn " for highlighting
  let &l:omnifunc = a:complete_func
endfunction

" OBJECT: s:InfoFileManager --------------------------------------------- {{{1
let s:InfoFileManager = { 'originals' : {} }

"
function! s:InfoFileManager.load()
  try
    let lines = readfile(expand(self.get_info_file()))
    " compatibility check
    if count(lines, self.get_info_version_line()) == 0
      call self.warn_old_info()
      let g:FuzzyFinderOptions.Base.info_file = ''
      throw 1
    endif
  catch /.*/ 
    let lines = []
  endtry
  for m in s:GetAvailableModes()
    call m.deserialize_info(lines)
  endfor
endfunction

"
function! s:InfoFileManager.save()
  let lines = [ self.get_info_version_line() ]
  for m in s:GetAvailableModes()
    let lines += m.serialize_info()
  endfor
  try
    call writefile(lines, expand(self.get_info_file()))
  catch /.*/ 
  endtry
endfunction

"
function! s:InfoFileManager.edit()
  new
  file `='[FuzzyfinderInfo]'`
  let self.bufnr = bufnr('%')
  setlocal filetype=vim
  setlocal bufhidden=delete
  setlocal buftype=acwrite
  setlocal noswapfile
  augroup FuzzyfinderInfo
    autocmd!
    autocmd BufWriteCmd <buffer> call s:InfoFileManager.on_buf_write_cmd()
  augroup END
  execute '0read ' . expand(self.get_info_file())
  setlocal nomodified
endfunction

"
function! s:InfoFileManager.on_buf_write_cmd()
  for m in s:GetAvailableModes()
    call m.deserialize_info(getline(1, '$'))
  endfor
  call self.save()
  setlocal nomodified
  execute printf('%dbdelete! ', self.bufnr)
  echo "Information file updated"
endfunction

"
function! s:InfoFileManager.get_info_version_line()
  return "VERSION\t217"
endfunction

"
function! s:InfoFileManager.get_info_file()
  return g:FuzzyFinderOptions.Base.info_file
endfunction

"
function! s:InfoFileManager.warn_old_info()
  call s:EchoWithHl(printf("=================================================================\n" .
        \                  "  Sorry, but your information file for Fuzzyfinder is no longer  \n" .
        \                  "  compatible with this version of Fuzzyfinder. Please remove     \n" .
        \                  "  %-63s\n" .
        \                  "=================================================================\n" ,
        \                  '"' . expand(self.get_info_file()) . '".'),
        \           'WarningMsg')
  echohl Question
  call input('Press Enter')
  echohl None
endfunction

" }}}1
"=============================================================================
" GLOBAL OPTIONS: {{{1
" stores user-defined g:FuzzyFinderOptions ------------------------------ {{{2
let s:user_options = (exists('g:FuzzyFinderOptions') ? g:FuzzyFinderOptions : {})
" }}}2

" Initializes g:FuzzyFinderOptions.
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{},
      \                      'MruFile':{}, 'MruCmd':{}, 'Bookmark':{},
      \                      'Tag':{}, 'TaggedFile':{},
      \                      'CallbackFile':{}, 'CallbackItem':{}, }
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.Base.key_open          = '<CR>'
let g:FuzzyFinderOptions.Base.key_open_split    = '<C-j>'
let g:FuzzyFinderOptions.Base.key_open_vsplit   = '<C-k>'
let g:FuzzyFinderOptions.Base.key_open_tab      = '<C-l>'
let g:FuzzyFinderOptions.Base.key_next_mode     = '<C-t>'
let g:FuzzyFinderOptions.Base.key_prev_mode     = '<C-y>'
let g:FuzzyFinderOptions.Base.key_ignore_case   = '<C-g><C-g>'
let g:FuzzyFinderOptions.Base.info_file         = '~/.vimfuzzyfinder'
let g:FuzzyFinderOptions.Base.min_length        = 0
let g:FuzzyFinderOptions.Base.abbrev_map        = {}
let g:FuzzyFinderOptions.Base.ignore_case       = 1
let g:FuzzyFinderOptions.Base.time_format       = '(%x %H:%M:%S)'
let g:FuzzyFinderOptions.Base.learning_limit    = 100
let g:FuzzyFinderOptions.Base.enumerating_limit = 100
let g:FuzzyFinderOptions.Base.max_menu_width    = 80
let g:FuzzyFinderOptions.Base.lasting_cache     = 1
let g:FuzzyFinderOptions.Base.migemo_support    = 0
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.Buffer.mode_available   = 1
let g:FuzzyFinderOptions.Buffer.prompt           = '>Buffer>'
let g:FuzzyFinderOptions.Buffer.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.Buffer.smart_bs         = 1
let g:FuzzyFinderOptions.Buffer.switch_order     = 10
let g:FuzzyFinderOptions.Buffer.reuse_window     = 1
let g:FuzzyFinderOptions.Buffer.mru_order        = 1
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.File.mode_available   = 1
let g:FuzzyFinderOptions.File.prompt           = '>File>'
let g:FuzzyFinderOptions.File.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.File.smart_bs         = 1
let g:FuzzyFinderOptions.File.switch_order     = 20
let g:FuzzyFinderOptions.File.reuse_window     = 1
let g:FuzzyFinderOptions.File.excluded_path    = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$'
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.Dir.mode_available   = 1
let g:FuzzyFinderOptions.Dir.prompt           = '>Dir>'
let g:FuzzyFinderOptions.Dir.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.Dir.smart_bs         = 1
let g:FuzzyFinderOptions.Dir.switch_order     = 30
let g:FuzzyFinderOptions.Dir.excluded_path    = ''
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.MruFile.mode_available   = 1
let g:FuzzyFinderOptions.MruFile.prompt           = '>MruFile>'
let g:FuzzyFinderOptions.MruFile.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.MruFile.smart_bs         = 1
let g:FuzzyFinderOptions.MruFile.switch_order     = 40
let g:FuzzyFinderOptions.MruFile.reuse_window     = 1
let g:FuzzyFinderOptions.MruFile.excluded_path    = '\v\~$|\.bak$|\.swp$'
let g:FuzzyFinderOptions.MruFile.max_item         = 200
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.MruCmd.mode_available   = 1
let g:FuzzyFinderOptions.MruCmd.prompt           = '>MruCmd>'
let g:FuzzyFinderOptions.MruCmd.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.MruCmd.smart_bs         = 0
let g:FuzzyFinderOptions.MruCmd.switch_order     = 50
let g:FuzzyFinderOptions.MruCmd.excluded_command = '^$'
let g:FuzzyFinderOptions.MruCmd.max_item         = 200
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.Bookmark.mode_available   = 1
let g:FuzzyFinderOptions.Bookmark.prompt           = '>Bookmark>'
let g:FuzzyFinderOptions.Bookmark.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.Bookmark.smart_bs         = 0
let g:FuzzyFinderOptions.Bookmark.switch_order     = 60
let g:FuzzyFinderOptions.Bookmark.reuse_window     = 1
let g:FuzzyFinderOptions.Bookmark.searching_range  = 100
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.Tag.mode_available   = 1
let g:FuzzyFinderOptions.Tag.prompt           = '>Tag>'
let g:FuzzyFinderOptions.Tag.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.Tag.smart_bs         = 0
let g:FuzzyFinderOptions.Tag.switch_order     = 70
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.TaggedFile.mode_available   = 1
let g:FuzzyFinderOptions.TaggedFile.prompt           = '>TaggedFile>'
let g:FuzzyFinderOptions.TaggedFile.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.TaggedFile.smart_bs         = 0
let g:FuzzyFinderOptions.TaggedFile.switch_order     = 80
let g:FuzzyFinderOptions.TaggedFile.reuse_window     = 1
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.CallbackFile.mode_available   = 1
let g:FuzzyFinderOptions.CallbackFile.prompt           = '>CallbackFile>'
let g:FuzzyFinderOptions.CallbackFile.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.CallbackFile.smart_bs         = 1
let g:FuzzyFinderOptions.CallbackFile.switch_order     = -1
let g:FuzzyFinderOptions.CallbackFile.excluded_path    = ''
"-----------------------------------------------------------------------------
let g:FuzzyFinderOptions.CallbackItem.mode_available   = 1
let g:FuzzyFinderOptions.CallbackItem.prompt           = '>CallbackItem>'
let g:FuzzyFinderOptions.CallbackItem.prompt_highlight = 'Question'
let g:FuzzyFinderOptions.CallbackItem.smart_bs         = 0
let g:FuzzyFinderOptions.CallbackItem.switch_order     = -1

" overwrites default values of g:FuzzyFinderOptions with user-defined values - {{{2
call map(s:user_options, 'extend(g:FuzzyFinderOptions[v:key], v:val, ''force'')')
call map(copy(g:FuzzyFinderMode), 'v:val.extend_options()')
" }}}2

" }}}1
"=============================================================================
" COMMANDS/AUTOCOMMANDS/MAPPINGS/ETC.: {{{1

let s:PATH_SEPARATOR = (has('win32') || has('win64') ? '\' : '/')
let s:MATCHING_RATE_BASE = 1000000
let s:ABBR_TRUNCATION_MARK = '...'
let s:OPEN_MODE_CURRENT = 1
let s:OPEN_MODE_SPLIT   = 2
let s:OPEN_MODE_VSPLIT  = 3
let s:OPEN_MODE_TAB     = 4

augroup FuzzyfinderGlobal
  autocmd!
  autocmd BufEnter     * for s:m in s:GetAvailableModes() | call s:m.extend_options() | call s:m.on_buf_enter() | endfor
  autocmd BufWritePost * for s:m in s:GetAvailableModes() | call s:m.extend_options() | call s:m.on_buf_write_post() | endfor
augroup END

if s:IsAvailableMode(g:FuzzyFinderMode.MruCmd)
  " cnoremap has a problem, which doesn't expand cabbrev.
  cmap <silent> <expr> <CR> <SID>OnCmdCR()
endif

command! -bang -narg=? -complete=buffer FuzzyFinderBuffer                    call g:FuzzyFinderMode.Buffer.launch    (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderFile                      call g:FuzzyFinderMode.File.launch      (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderFileWithFullCwd           call g:FuzzyFinderMode.File.launch      (fnamemodify(getcwd(), ':p') . <q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderFileWithCurrentBufferDir  call g:FuzzyFinderMode.File.launch      (expand('%:~:.')[:-1-len(expand('%:~:.:t'))] . <q-args>, len(<q-bang>))
command! -bang -narg=? -complete=dir    FuzzyFinderDir                       call g:FuzzyFinderMode.Dir.launch       (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=dir    FuzzyFinderDirWithFullCwd            call g:FuzzyFinderMode.Dir.launch       (fnamemodify(getcwd(), ':p') . <q-args>, len(<q-bang>))
command! -bang -narg=? -complete=dir    FuzzyFinderDirWithCurrentBufferDir   call g:FuzzyFinderMode.Dir.launch       (expand('%:p:~')[:-1-len(expand('%:p:~:t'))] . <q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderMruFile                   call g:FuzzyFinderMode.MruFile.launch   (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderMruCmd                    call g:FuzzyFinderMode.MruCmd.launch    (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderBookmark                  call g:FuzzyFinderMode.Bookmark.launch  (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=tag    FuzzyFinderTag                       call g:FuzzyFinderMode.Tag.launch       (<q-args>, len(<q-bang>))
command! -bang -narg=? -complete=tag    FuzzyFinderTagWithCursorWord         call g:FuzzyFinderMode.Tag.launch       (expand('<cword>') . <q-args>, len(<q-bang>))
command! -bang -narg=? -complete=file   FuzzyFinderTaggedFile                call g:FuzzyFinderMode.TaggedFile.launch(<q-args>, len(<q-bang>))
command! -bang -narg=?                  FuzzyFinderAddBookmark               call g:FuzzyFinderMode.Bookmark.bookmark_here(<q-args>)
command! -bang -narg=0 -range           FuzzyFinderAddBookmarkAsSelectedText call g:FuzzyFinderMode.Bookmark.bookmark_here(s:SelectedText())
command! -bang -narg=0                  FuzzyFinderEditInfo                  call s:InfoFileManager.edit()
command! -bang -narg=0                  FuzzyFinderRenewCache                for s:m in s:GetAvailableModes() | call s:m.empty_cache_if_existed(1) | endfor

" }}}1
"=============================================================================
" vim: set fdm=marker:
