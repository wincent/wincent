# Contributing

This repository includes a [GitHub Action] that builds the
colorschemes once a week. This keeps the colorschemes up-to-date
automatically.

## Building

### Dependencies

- `>=0.9.3` [tinted-builder-rust]

### Usage for template editing

1. Install [tinted-builder-rust]
1. `tinted-builder-rust build path/to/tinted-vim`

### Usage for adding or editing a colorscheme

1. Clone tinted-vim
1. Install [tinted-builder-rust]
1. Execute `tinted-builder-rust build path/to/tinted-vim`

```shell
tinted-builder-rust build /path/to/tinted-vim \
  --schemes-dir /path/to/tinted-schemes
```

If you have more questions about [tinted-builder-rust], have a look at
the information on the GitHub page.

[tinted-builder-rust]: https://github.com/tinted-theming/tinted-builder-rust
[tinted-schemes]: https://github.com/tinted-theming/schemes
[GitHub Action]: .github/workflows/update.yml

## Improving the highlights

1. Check out the help `:h tinted-vim` for an overview of all the highlights.
1. Use those mappings:

   ```vim
   command! -complete=highlight -nargs=1 HighlightHighlight execute 'highlight! link ' . <q-args> . ' Search'
   " See where a highlight is used.
   nn <leader>e :HighlightHighlight
   " Why does this element have this specific color?
   nn <silent><leader>i :Inspect<CR>
   " Reload colorscheme after changes to tinted-vim.
   nn <silent><leader>c :colorscheme base24-summerfruit-dark<cr>
   ```
