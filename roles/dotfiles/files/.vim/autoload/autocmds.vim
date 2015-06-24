" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
let g:WincentMkviewFiletypeBlacklist = ['hgcommit', 'gitcommit']

function! autocmds#should_mkview()
  return
        \ &buftype == '' &&
        \ index(g:WincentMkviewFiletypeBlacklist, &filetype) == -1
endfunction
