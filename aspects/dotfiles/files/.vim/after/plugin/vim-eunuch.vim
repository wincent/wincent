" vim-eunuch defines a ":W" command that I consider a little dangerous
" (too easy to type, with possibly wide-reaching side-effects); overwrite
" it with the ":W" command that I've been using for years
command! W w !sudo tee % > /dev/null
