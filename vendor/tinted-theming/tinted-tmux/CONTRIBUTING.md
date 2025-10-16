# Contributing

This repository includes a [GitHub Action] that builds the
colorschemes once a week. This keeps the colorschemes up-to-date
automatically.

## Building

### Dependencies

- `>=0.9.3` [tinted-builder-rust]

### Usage for template editing

1. Install [tinted-builder-rust]
1. `tinted-builder-rust build path/to/tinted-tmux`

### Usage for adding or editing a colorscheme

1. Clone the tinted-tmux
1. Clone [tinted-schemes]
1. Install [tinted-builder-rust]
1. Execute `tinted-builder-rust build tinted-tmux` with
  - `--schemes-dir` arg - provide `/path/to/tinted-schemes`

```shell
tinted-builder-rust build /path/to/tinted-tmux \
  --schemes-dir /path/to/tinted-schemes
```

If you have more questions about [tinted-builder-rust], have a look at
the information on the GitHub page.

[tinted-builder-rust]: https://github.com/tinted-theming/tinted-builder-rust
[tinted-schemes]: https://github.com/tinted-theming/schemes
[GitHub Action]: .github/workflows/update.yml
