vim.g.FerretExecutableArguments = {
  rg = table.concat(
    vim.list_extend({
      -- Defaults, as reported by `:echo ferret#get_default_arguments('rg')`:
      '--max-columns 4096',
      '--no-config',
      '--no-heading',
      '--vimgrep',
    }, {
      -- Additions, same as in `$HOME/.rgrc`:
      '--engine=auto',
      '--glob !.git',
      '--hidden',
    }),
    ' '
  ),
}
