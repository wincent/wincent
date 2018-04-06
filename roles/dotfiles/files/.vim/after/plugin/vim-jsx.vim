" Stop the vim-jsx plug-in from aggressively blowing away our ftdetection.
"
" Without something like this, our ftdetect/{jasmine,jsx}.vim config will
" set the filetype in test files to "javascript.jasmine" or
" "javascript.jasmine.jsx", but then vim-jsx will come along and unconditionally
" set it to "javascript.jsx", which isn't helpful. Currently I'm not working in
" any projects that use a ".jsx" extension so this workaround is viable
" (unfortunately, there's no other mechanism for disabling this functionality in
" vim-jsx).
let g:jsx_ext_required=1
