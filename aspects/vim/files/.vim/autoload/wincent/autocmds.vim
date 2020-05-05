let g:WincentColorColumnBufferNameBlacklist = []
let g:WincentColorColumnFileTypeBlacklist = ['command-t', 'diff', 'dirvish', 'fugitiveblame', 'undotree', 'qf']
let g:WincentCursorlineBlacklist = ['command-t']
let g:WincentMkviewFiletypeBlacklist = ['diff', 'hgcommit', 'gitcommit']

function! wincent#autocmds#attempt_select_last_file() abort
  let l:previous=expand('#:t')
  if l:previous !=# ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

function! wincent#autocmds#should_colorcolumn() abort
  if index(g:WincentColorColumnBufferNameBlacklist, bufname(bufnr('%'))) != -1
    return 0
  endif
  return index(g:WincentColorColumnFileTypeBlacklist, &filetype) == -1
endfunction

function! wincent#autocmds#should_cursorline() abort
  return index(g:WincentCursorlineBlacklist, &filetype) == -1
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
function! wincent#autocmds#should_mkview() abort
  return
        \ &buftype ==# '' &&
        \ index(g:WincentMkviewFiletypeBlacklist, &filetype) == -1 &&
        \ !exists('$SUDO_USER') " Don't create root-owned files.
endfunction

function! wincent#autocmds#mkview() abort
  try
    if exists('*haslocaldir') && haslocaldir()
      " We never want to save an :lcd command, so hack around it...
      cd -
      mkview
      lcd -
    else
      mkview
    endif
  catch /\<E186\>/
    " No previous directory: probably a `git` operation.
  catch /\<E190\>/
    " Could be name or path length exceeding NAME_MAX or PATH_MAX.
  endtry
endfunction

function! s:get_spell_settings() abort
  return {
        \   'spell': &l:spell,
        \   'spellcapcheck': &l:spellcapcheck,
        \   'spellfile': &l:spellfile,
        \   'spelllang': &l:spelllang
        \ }
endfunction

function! s:set_spell_settings(settings) abort
  let &l:spell=a:settings.spell
  let &l:spellcapcheck=a:settings.spellcapcheck
  let &l:spellfile=a:settings.spellfile
  let &l:spelllang=a:settings.spelllang
endfunction

function! wincent#autocmds#blur_window() abort
  if wincent#autocmds#should_colorcolumn()
    let l:settings=s:get_spell_settings()
    ownsyntax off
    set nolist
    if has('conceal')
      set conceallevel=0
    endif
    call s:set_spell_settings(l:settings)
  endif
endfunction

function! wincent#autocmds#focus_window() abort
  if wincent#autocmds#should_colorcolumn()
    if !empty(&ft)
      let l:settings=s:get_spell_settings()
      ownsyntax on
      set list
      let l:conceal_exclusions=get(g:, 'indentLine_fileTypeExclude', [])
      if has('conceal') && index(l:conceal_exclusions, &ft) == -1
        set conceallevel=1
      endif
      call s:set_spell_settings(l:settings)
    endif
  endif
endfunction

function! wincent#autocmds#blur_statusline() abort
  " Default blurred statusline (buffer number: filename).
  let l:blurred='%{wincent#statusline#gutterpadding()}'
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='%<' " truncation point
  let l:blurred.='%f' " filename
  let l:blurred.='%=' " split left/right halves (makes background cover whole)
  call s:update_statusline(l:blurred, 'blur')
endfunction

function! wincent#autocmds#focus_statusline() abort
  " `setlocal statusline=` will revert to global 'statusline' setting.
  call s:update_statusline('', 'focus')
endfunction

function! s:update_statusline(default, action) abort
  let l:statusline = s:get_custom_statusline(a:action)
  if type(l:statusline) == type('')
    " Apply custom statusline.
    execute 'setlocal statusline=' . l:statusline
  elseif l:statusline == 0
    " Do nothing.
    "
    " Note that order matters here because of Vimscript's insane coercion rules:
    " when comparing a string to a number, the string gets coerced to 0, which
    " means that all strings `== 0`. So, we must check for string-ness first,
    " above.
    return
  else
    execute 'setlocal statusline=' . a:default
  endif
endfunction

function! s:get_custom_statusline(action) abort
  if &ft ==# 'command-t'
    " Will use Command-T-provided buffer name, but need to escape spaces.
    return '\ \ ' . substitute(bufname('%'), ' ', '\\ ', 'g')
  elseif &ft ==# 'diff' && exists('t:diffpanel') && t:diffpanel.bufname ==# bufname('%')
    return 'Undotree\ preview' " Less ugly, and nothing really useful to show.
  elseif &ft ==# 'undotree'
    return 0 " Don't override; undotree does its own thing.
  elseif &ft ==# 'qf'
    if a:action ==# 'blur'
      return
            \ '%{wincent#statusline#gutterpadding()}'
            \ . '\ '
            \ . '\ '
            \ . '\ '
            \ . '\ '
            \ . '%<'
            \ . '%q'
            \ . '\ '
            \ . '%{get(w:,\"quickfix_title\",\"\")}'
            \ . '%='
    else
      return g:WincentQuickfixStatusline
    endif
  endif

  return 1 " Use default.
endfunction

function! wincent#autocmds#idleboot() abort
  " Make sure we automatically call wincent#autocmds#idleboot() only once.
  augroup WincentIdleboot
    autocmd!
  augroup END

  " Make sure we run deferred tasks exactly once.
  doautocmd User WincentDefer
  autocmd! User WincentDefer
endfunction

" Directories where we want to perform auto-encryption on save.
let s:encrypted={}
let s:encrypted[expand('~/code/ansible-configs')]='vendor/git-cipher/bin/git-cipher'
let s:encrypted[expand('~/code/wincent')]='vendor/git-cipher/bin/git-cipher'

" Update encryptable files after saving.
function! wincent#autocmds#encrypt(file) abort
  let l:base=fnamemodify(a:file, ':h')
  let l:directories=keys(s:encrypted)
  for l:directory in l:directories
    if stridx(a:file, l:directory) == 0
      let l:encrypted=l:base . '/.' . fnamemodify(a:file, ':t') . '.encrypted'
      if filewritable(l:encrypted) == 1
        let l:executable=l:directory . '/' . s:encrypted[l:directory]
        if executable(l:executable)
          call system(
                \   fnamemodify(l:executable, ':S') .
                \   ' encrypt ' .
                \   shellescape(a:file)
                \ )
        endif
      endif
      break
    endif
  endfor
endfunction

" TODO move all this into a separate file
let g:WincentEditorConfigPathBlacklist=[]

let g:WincentEditorConfigFileTypeBlacklist=[
      \   'command-t',
      \   'diff',
      \   'dirvish',
      \   'fugitiveblame',
      \   'gitcommit',
      \   'hgcommit',
      \   'qf',
      \   'undotree'
      \ ]

function! s:editorconfig_blacklist(path, filetype)
  for l:item in g:WincentEditorConfigPathBlacklist
    if match(a:path, l:item) != -1
      return 1
    endif
  endfor

  for l:item in g:WincentEditorConfigFileTypeBlacklist
    if match(a:filetype, l:item) != -1
      return 1
    endif
  endfor

  return 0
endfunction

function! wincent#autocmds#apply_overrides() abort
  let l:path=expand('%:p')
  if empty(l:path)
    return
  endif
  if s:editorconfig_blacklist(l:path, &filetype)
    return
  endif
  let l:editorconfig=wincent#autocmds#editorconfig(l:path)

  " TODO: Deal with more kinds of globs
  " typical examples:
  "     *           any file
  "     *.js        any js file
  "     lib/**.js   any js file under lib (at any level)
  "     *.{js,ts}   any js or ts file
  " meaning of each char:
  "     *           match run of any char except /
  "     **          match any run of chars
  "     ?           any single char
  "     [abc]       any single char of a, b, c
  "     [!abc]      any single char not in set a, b, c
  "     {a,b,c}     a or b or c (can be nested, gulp)
  "     {-10..10}   numbers between -10 and 10
  "     \\          escape

  for l:config in l:editorconfig
    let l:glob=l:config.name

    if len(l:glob) > 4096
      " Ignore overlength sections, as per:
      " https://editorconfig-specification.readthedocs.io/en/latest/#glob-expressions
      continue
    endif

    " TODO: don't backslash-escape already-escaped things
    let l:glob=substitute(l:glob, '\v\.', '\\.', 'g')
    let l:glob=substitute(l:glob, '\v\*\*', '.+', 'g')
    let l:glob=substitute(l:glob, '\v\*', '[^/]+', 'g')

    " TODO: replace this hack with real thing:
    let l:glob=substitute(l:glob, '\v\{', '(', 'g')
    let l:glob=substitute(l:glob, '\v\}', ')', 'g')
    let l:glob=substitute(l:glob, '\v,', '|', 'g')

    try
      let l:match=match(l:path, '\v' . l:glob . '$')
    catch
      " Don't die due to an invalid pattern.
      let l:match=-1
    endtry

    if l:match != -1
      " BUG: won't handle unsaved files; maybe that is ok
      for l:pair in items(l:config.pairs)
        let l:key=l:pair[0]
        let l:value=l:pair[1]
        if l:key == 'indent_style'
          if l:value == 'space'
            setlocal expandtab
          else
            setlocal noexpandtab

            if match(&formatprg, '^par ') != -1
              " "T", turns tabs to spaces, and I can't seem to turn it off, but I can
              " at least make it use the right number of them...
              let &l:formatprg=substitute(&formatprg, 'T\d*', 'T4', '')

              " ... and then override the |gq| operator to do a |:retab!| after
              " applying.
              map <buffer> gq <Plug>(operator-format-and-retab)
              call operator#user#define('format-and-retab', 'wincent#autocmds#format')
            endif

          endif
        elseif l:key == 'indent_size'
          let &l:shiftwidth=l:value
          let &l:tabstop=l:value
        elseif l:key == 'insert_final_newline'
          if l:value == 'true'
            let &l:endofline=1
            let &l:fixendofline=1
          else
            let &l:endofline=0
            let &l:fixendofline=0
          endif
        endif
      endfor
    endif
  endfor
endfunction

" For full list of possible keys, see:
"
"     https://editorconfig-specification.readthedocs.io/en/latest/
"
" We only support a restrictive subset for now.
let s:editorconfig_keys={
      \   'indent_style': ['tab', 'space'],
      \   'indent_size': ['tab', '1', '2', '3', '4', '5', '6', '7', '8'],
      \   'insert_final_newline': ['true', 'false'],
      \   'tab_width': ['1', '2', '3', '4', '5', '6', '7', '8']
      \ }

" Traverse upwards looking for an .editorconfig.
"
" Implements a subset of the functionality described at: https://editorconfig.org/
"
" @param {file} path of current file(either absolute or relative to cwd)
"
" If there is no filename yet, `file` will be the same as its 'filetype', but
" that serves adequately for the purposes of this function.
function! wincent#autocmds#editorconfig(file) abort
  " Make absolute path.
  let l:path=fnamemodify(a:file, ':p')

  while 1
    " Get dirname.
    let l:path=fnamemodify(l:path, ':h')
    let l:candidate=l:path . '/.editorconfig'
    if filereadable(l:candidate)
      break
    endif
    if l:path == '' || l:path == '/'
      return []
    endif
  endwhile

  let l:config=[]
  let l:section=v:null

  " Only read first 100 lines of .editorconfig, to prevent possible abuse.
  let l:lines=readfile(l:candidate, '', 100)

  let l:root=0

  for l:line in l:lines
    if match(l:line, '\v^\s*$') != -1
      " Blank line, skip.
    elseif match(l:line, '\v^\s*[#;]') != -1
      " Comment, skip.
    else
      let l:header=matchlist(l:line, '\v^\s*\[([^\]]+)\]\s*$')
      if !empty(l:header)
        " Starting a section.
        let l:section={'name': l:header[1], 'pairs': {}}
        call add(l:config, l:section)
      else
        let l:pair=matchlist(l:line, '\v^\s*([^=]{-})\s*\=\s*(\S.{-})\s*$')
        if !empty(l:pair)
          " Adding key/value pair to current section.
          let l:key=tolower(l:pair[1])
          let l:value=tolower(l:pair[2])
          if type(l:section) == type(v:null)
            if l:key == 'root'
              " 'root' in preamble.
              "
              " Possible values: 'true' or 'false'.
              if l:value == 'true'
                let l:root=1
              endif
            else
              " Ignore non-'root' key in preamble.
            endif
          else
            if l:key == 'root'
              " Ignore 'root' outside of preamble.
            elseif has_key(s:editorconfig_keys, l:key)
              " Non-'root' outside of preamble.
              if l:value == 'unset'
                " Remove the key, if present.
                if has_key(l:section.pairs, l:key)
                  call remove(l:section.pairs, l:key)
                endif
              elseif index(get(s:editorconfig_keys, l:key), l:value) != -1
                " Legit value for this key.
                let l:section.pairs[l:key]=l:value
              else
                " Invalid/unsupported value.
              endif
            else
              " Unknown key.
            endif
          endif
        else
          " Unknown format, skip.
        endif
      endif
    endif
  endfor

  if l:root == 0 && l:path != '' && l:path != '/'
    " Walk up recursively looking for ancestor config(s).
    let l:parent=fnamemodify(l:path, ':h')
    return extend(wincent#autocmds#editorconfig(l:parent), l:config)
  else
    return l:config
  end
endfunction

function! wincent#autocmds#format(motion) abort
  if has('ex_extra')
    let l:v=operator#user#visual_command_from_wise_name(a:motion)
    silent execute 'normal!' '`[' . l:v . '`]gq'
    '[,']retab!
  endif
endfunction
