set conceallevel=2
set concealcursor=nc

" https://groups.google.com/forum/#!topic/vim_dev/M8FBQIM6-aY
let s:path=resolve(expand('<sfile>:p:h:h')) . '/after'
execute 'set rtp+=' . s:path
