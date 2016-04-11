function! statusline#gutterpadding(subtractBufferNumber) abort
  let l:gutterWidth=max([strlen(line('$')), &numberwidth]) + 1
  let l:bufferNumberWidth=a:subtractBufferNumber ? strlen(winbufnr(0)) : 0
  let l:padding=repeat(' ', l:gutterWidth - l:bufferNumberWidth - 1)
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
  let l:prefix=has('gui') ? 'gui' : 'cterm'
  let l:fg=synIDattr(synIDtrans(hlID('Error')), 'bg')
  let l:bg=synIDattr(synIDtrans(hlID('StatusLine')), 'bg')
  execute 'highlight User4 ' . l:prefix . 'fg=' . l:fg . ' ' . l:prefix . 'bg=' . l:bg

  " Right-hand side section.
  let l:bg=synIDattr(synIDtrans(hlID('User2')), 'fg')
  let l:fg=synIDattr(synIDtrans(hlID('User3')), 'fg')
  execute 'highlight User5 ' . l:prefix . '=bold ' . l:prefix . 'fg=' . l:bg . ' ' . l:prefix . 'bg=' . l:fg

  " Right-hand side section + italic (used for %).
  execute 'highlight User6 ' . l:prefix . '=bold,italic ' . l:prefix . 'fg=' . l:bg . ' ' . l:prefix . 'bg=' . l:fg

  " Make not-current window status lines visible against ColorColumn background.
  " Note that we can't use an exact copy of StatusLine here because in that case
  " Vim will helpfully(?) fill in the background with "^^^".
  highlight clear StatusLineNC
  highlight! link StatusLineNC User2
endfunction
