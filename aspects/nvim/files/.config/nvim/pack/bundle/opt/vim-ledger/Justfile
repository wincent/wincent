git := which('git')
just := just_executable()
nvim := which('nvim')
vim := which('vim')

set unstable := true

ledger := "ledger"

[default]
[private]
@list:
    {{ just }} --list --unsorted

[no-cd]
preview-vim *ARGS: (preview vim + ' --clean' ARGS)

[no-cd]
preview-nvim *ARGS: (preview nvim + ' --clean' ARGS)

[no-cd]
[private]
preview vimcmd *ARGS:
    {{ vimcmd }} \
        -c 'let g:ledger_bin = "{{ ledger }}"' \
        -c {{ quote("let &runtimepath=\"" + justfile_directory() + ",\" . &runtimepath") }} \
        -c 'filetype detect' \
        {{ ARGS }}

[no-cd]
check-vim *ARGS: (check vim + ' --clean -N' ARGS)

[no-cd]
check-nvim *ARGS: (check nvim + ' --clean --headless' ARGS)

[no-cd]
[private]
check vimcmd *ARGS:
    test -d vader.vim || {{ git }} clone --depth 1 https://github.com/junegunn/vader.vim.git
    {{ vimcmd }} \
        -c 'let g:ledger_bin = "{{ ledger }}"' \
        -c {{ quote("let &runtimepath=\"" + justfile_directory() + "/vader.vim," + justfile_directory() + ",\" . &runtimepath") }} \
        -c 'filetype detect' \
        -c 'source vader.vim/plugin/vader.vim' \
        {{ ARGS }} \
        '+Vader! spec/*'
