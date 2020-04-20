" Work around filetype that landed in upstream Vim here:
" https://github.com/vim/vim/issues/4830
execute 'noautocmd set filetype=' . substitute(&filetype, 'javascriptreact', 'javascript', '')
