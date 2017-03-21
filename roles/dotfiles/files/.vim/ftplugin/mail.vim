" See also: after/ftplugin/mail.vim.

setlocal nolist
setlocal spell

" Could also try to detect and set the right languages automatically
" (see https://gist.github.com/arenevier/1142114)
" but going with something dumb and simple for now.
setlocal spelllang=en,es

nnoremap <buffer> j gj
nnoremap <buffer> k gk
