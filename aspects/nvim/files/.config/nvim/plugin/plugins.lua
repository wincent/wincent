vim.defer_fn(wincent.plugins.abolish, 0)

wincent.lazy({
  pack = 'undotree',
  plugin = 'undotree.vim',
  nnoremap = {
    ['<Leader>u'] = {':UndotreeToggle<CR>', {silent = true}},
  },
  beforeload = {
    function()
      vim.g.undotree_HighlightChangedText = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_DiffCommand = 'diff -u'

      -- Mappings to emulate Gundo behavior.
      vim.cmd([[
        function! g:Undotree_CustomMap() abort
          " Normally j, k just move and J, K actually revert;
          " let's make j, k revert too.
          nmap <buffer> j <Plug>UndotreePreviousState
          nmap <buffer> k <Plug>UndotreeNextState

          " Equivalent to `g:gundo_close_on_revert=1`:
          nmap <buffer> <Return> <Plug>UndotreeClose
        endfunction
      ]])
    end,
  }
})
