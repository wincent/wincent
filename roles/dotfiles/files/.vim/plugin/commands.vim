command! -nargs=* -complete=file Preview call commands#preview(<f-args>)

command! -nargs=1 Substitute call mappings#substitute(<q-args>)
