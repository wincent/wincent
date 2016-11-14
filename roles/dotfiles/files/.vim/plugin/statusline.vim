scriptencoding utf-8

" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
if has('statusline')
  set statusline=%7*                         " Switch to User7 highlight group
  set statusline+=%{statusline#gutterpadding(1)}
  set statusline+=%n                         " Buffer number.
  set statusline+=\                          " Space.
  set statusline+=%*                         " Reset highlight group.
  set statusline+=%4*                        " Switch to User4 highlight group (Powerline arrow).
  set statusline+=                          " Powerline arrow.
  set statusline+=%*                         " Reset highlight group.
  set statusline+=\                          " Space.
  set statusline+=%<                         " Truncation point, if not enough width available.
  set statusline+=%{statusline#fileprefix()} " Relative path to file's directory.
  set statusline+=%3*                        " Switch to User3 highlight group (bold).
  set statusline+=%t                         " Filename.
  set statusline+=%*                         " Reset highlight group.
  set statusline+=\                          " Space.
  set statusline+=%1*                        " Switch to User1 highlight group (italics).

  " Needs to be all on one line:
  "   %(                   Start item group.
  "   [                    Left bracket (literal).
  "   %M                   Modified flag: ,+/,- (modified/unmodifiable) or nothing.
  "   %R                   Read-only flag: ,RO or nothing.
  "   %{statusline#ft()}   Filetype (not using %Y because I don't want caps).
  "   %{statusline#fenc()} File-encoding if not UTF-8.
  "   ]                    Right bracket (literal).
  "   %)                   End item group.
  set statusline+=%([%M%R%{statusline#ft()}%{statusline#fenc()}]%)

  set statusline+=%*   " Reset highlight group.
  set statusline+=%=   " Split point for left and right groups.

  set statusline+=\               " Space.
  set statusline+=               " Powerline arrow.
  set statusline+=%5*             " Switch to User5 highlight group.
  set statusline+=\               " Space.
  set statusline+=ℓ               " (Literal, \u2113 "SCRIPT SMALL L").
  set statusline+=\               " Space.
  set statusline+=%l              " Current line number.
  set statusline+=/               " Separator.
  set statusline+=%L              " Number of lines in buffer.
  set statusline+=\               " Space.
  set statusline+=𝚌               " (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
  set statusline+=\               " Space.
  set statusline+=%v              " Current virtual column number.
  set statusline+=/               " Separator.
  set statusline+=%{virtcol('$')} " Line width in virtual columns.
  set statusline+=\               " Space.
  set statusline+=%*              " Reset highlight group.
  set statusline+=%6*             " Switch to User6 highlight group.
  set statusline+=%p              " Percentage through buffer.
  set statusline+=%%              " Literal %.
  set statusline+=%*              " Reset highlight group.

  if has('autocmd')
    augroup WincentStatusline
      autocmd!
      autocmd ColorScheme * call statusline#update_highlight()
      autocmd User FerretAsyncStart call statusline#async_start()
      autocmd User FerretAsyncFinish call statusline#async_finish()
    augroup END
  endif
endif
