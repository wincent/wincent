-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md
return {
  { mapping = 'ac', textobject = '@comment.outer', desc = 'Select a comment' },
  { mapping = 'ic', textobject = '@comment.inner', desc = 'Select comment contents' },
  { mapping = 'af', textobject = '@function.outer', desc = 'Select a function' },
  { mapping = 'if', textobject = '@function.inner', desc = 'Select a function body' },
  { mapping = 'ak', textobject = '@class.outer', desc = 'Select a class' },
  { mapping = 'ik', textobject = '@class.inner', desc = 'Select a class body' },
  { mapping = 'al', textobject = '@loop.outer', desc = 'Select a loop' },
  { mapping = 'il', textobject = '@loop.inner', desc = 'Select a loop body' },
  { mapping = 'ar', textobject = '@block.outer', desc = 'Select a block' },
  { mapping = 'ir', textobject = '@block.inner', desc = 'Select a block body' },
}
