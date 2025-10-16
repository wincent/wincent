# cmp-path

nvim-cmp source for filesystem paths.

# Setup

support path alias, But don't start too much at a time, or there will be performance issues
```lua
require'cmp'.setup {
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        {
        name = 'path',
        option = {
            pathMappings = {
                ['@'] = '${folder}/src',
                -- ['/'] = '${folder}/src/public/',
                -- ['~@'] = '${folder}/src',
                -- ['/images'] = '${folder}/src/images',
                -- ['/components'] = '${folder}/src/components',
            },
        },
        },
        { name = 'buffer' },
        { name = 'luasnip' },
    }),
}
```


## Configuration

The below source configuration options are available. To set any of these options, do:

```lua
cmp.setup({
  sources = {
    {
      name = 'path',
      option = {
        -- Options go into this table
      },
    },
  },
})
```


### trailing_slash (type: boolean)

_Default:_ `false`

Specify if completed directory names should include a trailing slash. Enabling this option makes this source behave like Vim's built-in path completion.

### label_trailing_slash (type: boolean)

_Default:_ `true`

Specify if directory names in the completion menu should include a trailing slash.

### get_cwd (type: function)

_Default:_ returns the current working directory of the current buffer

Specifies the base directory for relative paths.
