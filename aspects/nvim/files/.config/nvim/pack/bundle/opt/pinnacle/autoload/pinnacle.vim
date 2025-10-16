""
" @plugin Pinnacle Highlight group manipulation for Vim
"
" # Intro
"
" Pinnacle provides functions for manipulating |:highlight| groups in Vimscript
" (eg. |pinnacle#italicize|) and Lua (eg.
" `require'wincent.pinnacle'.italicize()`).
"
" # Installation
"
" To install Pinnacle, use your plug-in management system of choice.
"
" If you don't have a "plug-in management system of choice", I recommend
" Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and
" robustness. Assuming that you have Pathogen installed and configured, and that
" you want to install Pinnacle into `~/.vim/bundle`, you can do so with:
"
" ```
" git clone https://github.com/wincent/pinnacle.git ~/.vim/bundle/pinnacle
" ```
"
" Alternatively, if you use a Git submodule for each Vim plug-in, you could do
" the following after `cd`-ing into the top-level of your Git superproject:
"
" ```
" git submodule add https://github.com/wincent/pinnacle.git ~/vim/bundle/pinnacle
" git submodule init
" ```
"
" To generate help tags under Pathogen, you can do so from inside Vim with:
"
" ```
" :call pathogen#helptags()
" ```
"
" @footer
"
" # Website
"
" Source code:
"
"   - https://github.com/wincent/pinnacle
"   - https://gitlab.com/wincent/pinnacle
"   - https://bitbucket.org/ghurrell/pinnacle
"
" Official releases are listed at:
"
"   http://www.vim.org/scripts/script.php?script_id=5360
"
"
" # License
"
" Copyright (c) 2016-present Greg Hurrell
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"
" # Development
"
" ## Contributing patches
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/pinnacle/pulls
"
" ## Cutting a new release
"
" At the moment the release process is manual:
"
" - Perform final sanity checks and manual testing
" - Update the |pinnacle-history| section of the documentation
" - Verify clean work tree:
"
" ```
" git status
" ```
"
" - Tag the release:
"
" ```
" git tag -s -m "$VERSION release" $VERSION
" ```
"
" - Publish the code:
"
" ```
" git push origin main --follow-tags
" git push github main --follow-tags
" ```
"
" - Produce the release archive:
"
" ```
" git archive -o pinnacle-$VERSION.zip HEAD -- .
" ```
"
" - Upload to http://www.vim.org/scripts/script.php?script_id=5360
"
"
" # Authors
"
" Pinnacle is written and maintained by Greg Hurrell <greg@hurrell.net>.
"
" Other contributors that have submitted patches include (in alphabetical
" order):
"
" - Cody Buell
" - Khue Nguyen
" - Kyle Poole
"
"
" # History
"
" ## main (not yet released)
"
" - Taught `pinnacle#decorate()` to accept a comma-separated list of styles.
" - Added alternative Lua-based API (eg. `require'wincent.pinnacle'.italicize()`
"   is equivalent to `pinnacle#italicize()` etc); but note:
" - Removed functions that aren't needed in the Lua API: `pinnacle.extract_bg()`,
"   `pinnacle.capture_highlight()`, `pinnacle.extract_component()`,
"   `pinnacle.extract_fg()`, `pinnacle.extract_highlight()`, and
"   `pinnacle.highlight()`. Equivalent functionality can be obtained by using
"   the convenience functions listed below, along with `pinnacle.decorate()` and
"   `pinnacle.dump()`.
" - Added convenience functions for common operations to the Lua API:
"   `pinnacle.bg()`, `pinnacle.clear()`, `pinnacle.fg()`, `pinnacle.link()`,
"   `pinnacle.merge()`, and `pinnacle.set()`.
" - Added utility functions to the Lua API: `pinnacle.adjust_lightness()`,
"   `pinnacle.brighten()` and `pinnacle.darken()`.
"
" ## 1.0 (6 March 2019)
"
" - Added `pinnacle#dump()`.
"
" ## 0.3.1 (7 June 2017)
"
" - Fix another bug with augmentation of existing highlights.
"
" ## 0.3 (6 June 2017)
"
" - Added `pinnacle#extract_bg` and `pinnacle#extract_fg`.
" - Fixed bug that could cause existing highlights to be incorrectly
"   augmented.
"
" ## 0.2 (9 January 2017)
"
" - Added `pinnacle#underline`.
"
" ## 0.1 (30 March 2016)
"
" - Initial release.

""
" @function pinnacle#sub_newlines
"
" Replaces newlines with spaces.
"
" Note that this function is not implemented in the Lua API, because it is
" required only for support on legacy Vim versions.
"
function! pinnacle#sub_newlines(string) abort
  return tr(a:string, "\r\n", '  ')
endfunction

function s:execute(command)
  execute a:command
endfunction

""
" @function pinnacle#capture_line
"
" Runs a command and returns the captured output as a single line.
"
" Useful when we don't want to let long lines on narrow windows produce unwanted
" embedded newlines.
"
" Note that this function is not implemented in the Lua API, because it is
" required only for support on legacy Vim versions.
"
function! pinnacle#capture_line(command) abort
  if exists('*execute')
    let l:capture=execute(a:command)
  else
    redir => l:capture
    silent call s:execute(a:command)
    redir END
  endif

  return pinnacle#sub_newlines(l:capture)
endfunction

""
" @function pinnacle#capture_highlight
"
" Gets the current value of a highlight group.
"
function! pinnacle#capture_highlight(group) abort
  return pinnacle#capture_line('0verbose silent highlight ' . a:group)
endfunction

""
" @function pinnacle#extract_highlight
"
" Extracts a highlight string from a group, recursively traversing linked
" groups, and returns a string suitable for passing to `:highlight`.
"
function! pinnacle#extract_highlight(group) abort
  let l:group = pinnacle#capture_highlight(a:group)

  " Traverse links back to authoritative group.
  while l:group =~# 'links to'
    let l:index = stridx(l:group, 'links to') + len('links to')
    let l:linked = strpart(l:group, l:index + 1)
    let l:group = pinnacle#capture_highlight(l:linked)
  endwhile

  " Extract the highlighting details (the bit after "xxx")
  let l:matches = matchlist(l:group, '\<xxx\>\s\+\(.*\)')
  let l:original = l:matches[1]
  return l:original
endfunction

let s:prefix=has('gui') || (has('termguicolors') && &termguicolors) ? 'gui' : 'cterm'

""
" @function pinnacle#extract_bg
"
" Extracts just the bg portion of the specified highlight group.
"
function! pinnacle#extract_bg(group) abort
  return pinnacle#extract_component(a:group, 'bg')
endfunction

""
" @function pinnacle#extract_fg
"
" Extracts just the bg portion of the specified highlight group.
"
function! pinnacle#extract_fg(group) abort
  return pinnacle#extract_component(a:group, 'fg')
endfunction

""
" @function pinnacle#extract_component
"
" Extracts a single component (eg. "bg", "fg", "italic" etc) from the specified
" highlight group.
"
function! pinnacle#extract_component(group, component) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:component)
endfunction

""
" @function pinnacle#dump
"
" Returns a dictionary representation of the specified highlight group.
"
function! pinnacle#dump(highlight) abort
  return filter({
        \   'bg': pinnacle#extract_component(a:highlight, 'bg'),
        \   'fg': pinnacle#extract_component(a:highlight, 'fg'),
        \   s:prefix: join(
        \     filter([
        \       pinnacle#extract_component(a:highlight, 'bold') ? 'bold' : '',
        \       pinnacle#extract_component(a:highlight, 'inverse') ? 'inverse' : '',
        \       pinnacle#extract_component(a:highlight, 'italic') ? 'italic' : '',
        \       pinnacle#extract_component(a:highlight, 'reverse') ? 'reverse' : '',
        \       pinnacle#extract_component(a:highlight, 'standout') ? 'standout' : '',
        \       pinnacle#extract_component(a:highlight, 'undercurl') ? 'undercurl' : '',
        \       pinnacle#extract_component(a:highlight, 'underline') ? 'underline': ''
        \     ], 'v:val != ""'),
        \   ',')
        \ }, 'v:val != ""')
endfunction

""
" @function pinnacle#highlight
"
" Returns a string representation of a dictionary containing bg, fg, term, cterm
" and guiterm entries.
"
function! pinnacle#highlight(highlight) abort
  let l:result=[]
  if has_key(a:highlight, 'bg')
    call insert(l:result, s:prefix . 'bg=' . a:highlight['bg'])
  endif
  if has_key(a:highlight, 'fg')
    call insert(l:result, s:prefix . 'fg=' . a:highlight['fg'])
  endif
  if has_key(a:highlight, 'term')
    call insert(l:result, s:prefix . '=' . a:highlight['term'])
  endif
  if has_key(a:highlight, 'cterm')
    call insert(l:result, s:prefix . '=' . a:highlight['cterm'])
  endif
  if has_key(a:highlight, 'guiterm')
    call insert(l:result, s:prefix . '=' . a:highlight['guiterm'])
  endif
  return join(l:result, ' ')
endfunction

""
" @function pinnacle#italicize
"
" Returns an italicized copy of `group` suitable for passing to `:highlight`.
"
function! pinnacle#italicize(group) abort
  return pinnacle#decorate('italic', a:group)
endfunction

""
" @function pinnacle#embolden
"
" Returns a bold copy of `group` suitable for passing to `:highlight`.
"
function! pinnacle#embolden(group) abort
  return pinnacle#decorate('bold', a:group)
endfunction

""
" @function pinnacle#underline
"
" Returns an underlined copy of `group` suitable for passing to `:highlight`.
"
function! pinnacle#underline(group) abort
  return pinnacle#decorate('underline', a:group)
endfunction

function! s:trim(string)
  if exists('*trim')
    return trim(a:string)
  else
    return substitute(a:string, '\v^\s+(\S*)\s+$', '\1', '')
  endif
endfunction

""
" @function pinnacle#decorate
"
" Returns a copy of `group` decorated with `style` (eg. "bold", "italic" etc)
" suitable for passing to `:highlight`.
"
" To decorate with multiple styles, `style` should be a comma-separated list.
"
function! pinnacle#decorate(style, group) abort
  let l:original = pinnacle#extract_highlight(a:group)

  for l:lhs in ['gui', 'term', 'cterm']
    " Check for existing setting.
    let l:matches = matchlist(
      \   l:original,
      \   '^\(\%([^ ]\+ \)*\)' .
      \   '\(' . l:lhs . '=[^ ]\+\)' .
      \   '\(\%( [^ ]\+\)*\)$'
      \ )
    if empty(l:matches)
      " No setting, add one with just a:style in it
      let l:original .= ' ' . l:lhs . '=' . a:style
    else
      " Existing setting; check whether a:style is already in it.
      let l:start = l:matches[1]
      let l:value = l:matches[2]
      let l:end = l:matches[3]
      for l:style in split(a:style, ',')
        let l:trimmed=s:trim(l:style)
        if l:value =~# '\<' . l:trimmed . '\>'
          continue
        else
          let l:value .= ',' . l:trimmed
        endif
      endfor
      let l:original = l:start . l:value . l:end
    endif
  endfor

  return pinnacle#sub_newlines(l:original)
endfunction
