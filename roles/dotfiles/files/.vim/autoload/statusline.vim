function! statusline#gutterpadding() abort
  let l:minwidth=2
  let l:gutterWidth=max([strlen(line('$')) + 1, &numberwidth, l:minwidth])
  let l:padding=repeat(' ', l:gutterWidth - 1)
  return l:padding
endfunction

function! statusline#fileprefix() abort
  let l:basename=expand('%:h')
  if l:basename == '' || l:basename == '.'
    return ''
  else
    " Make sure we show $HOME as ~.
    return substitute(l:basename . '/', '\C^' . $HOME, '~', '')
  endif
endfunction

function! statusline#ft() abort
  if strlen(&ft)
    return ',' . &ft
  else
    return ''
  endif
endfunction

function! statusline#fenc() abort
  if strlen(&fenc) && &fenc !=# 'utf-8'
    return ',' . &fenc
  else
    return ''
  endif
endfunction

function! statusline#lhs() abort
  let l:line=statusline#gutterpadding()
  let l:line.=&modified ? '+ ' : '  '
  return l:line
endfunction

function! statusline#rhs() abort
  let l:line=' '
  if winwidth(0) > 80
    let l:line.='ℓ ' " (Literal, \u2113 "SCRIPT SMALL L").
    let l:line.=line('.')
    let l:line.='/'
    let l:line.=line('$')
    let l:line.=' 𝚌 ' " (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
    let l:line.=virtcol('.')
    let l:line.='/'
    let l:line.=virtcol('$')
    let l:line.=' '
  endif
  return l:line
endfunction

let s:wincent_statusline_status_highlight='Identifier'

function! statusline#async_start() abort
  let s:wincent_statusline_status_highlight='Constant'
  call statusline#update_highlight()
endfunction

function! statusline#async_finish() abort
  let s:wincent_statusline_status_highlight='Identifier'
  call statusline#update_highlight()
endfunction

function! statusline#update_highlight() abort
  " Update StatusLine to use italics (used for filetype).
  let l:highlight=pinnacle#italicize('StatusLine')
  execute 'highlight User1 ' . l:highlight

  " Update MatchParen to use italics (used for blurred statuslines).
  let l:highlight=pinnacle#italicize('MatchParen')
  execute 'highlight User2 ' . l:highlight

  " StatusLine + bold (used for file names).
  let l:highlight=pinnacle#embolden('StatusLine')
  execute 'highlight User3 ' . l:highlight

  " Inverted Error styling, for left-hand side "Powerline" triangle.
  let l:fg=pinnacle#extract_fg(s:wincent_statusline_status_highlight)
  let l:bg=pinnacle#extract_bg('StatusLine')
  execute 'highlight User4 ' . pinnacle#highlight({'bg': l:bg, 'fg': l:fg})

  " And opposite for the buffer number area.
  execute 'highlight User7 ' .
        \ pinnacle#highlight({
        \   'bg': l:fg,
        \   'fg': pinnacle#extract_fg('Normal'),
        \   'term': 'bold'
        \ })

  " Right-hand side section.
  let l:bg=pinnacle#extract_fg('Cursor')
  let l:fg=pinnacle#extract_fg('User3')
  execute 'highlight User5 ' .
        \ pinnacle#highlight({
        \   'bg': l:fg,
        \   'fg': l:bg,
        \   'term': 'bold'
        \ })

  " Right-hand side section + italic (used for %).
  execute 'highlight User6 ' .
        \ pinnacle#highlight({
        \   'bg': l:fg,
        \   'fg': l:bg,
        \   'term': 'bold,italic'
        \ })

  highlight clear StatusLineNC
  highlight! link StatusLineNC User1
endfunction
