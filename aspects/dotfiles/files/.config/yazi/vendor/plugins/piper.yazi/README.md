# piper.yazi

Pipe any shell command as a previewer.

## Installation

```sh
ya pkg add yazi-rs/plugins:piper
```

## Usage

Piper is a general-purpose previewer - you can pass any shell command to `piper` and it will use the command's output as the preview content.

It accepts a string parameter, which is the shell command to be executed, for example:

```toml
# ~/.config/yazi/yazi.toml
[[plugin.prepend_previewers]]
url = "*"
run = 'piper -- echo "$1"'
```

This will set `piper` as the previewer for all file types and use `$1` (file path) as the preview content.

## Variables

Available variables:

- `$w`: the width of the preview area.
- `$h`: the height of the preview area.
- `$1`: the path to the file being previewed.

## Examples

Here are some configuration examples:

### Preview tarballs with [`tar`](https://man7.org/linux/man-pages/man1/tar.1.html)

```toml
[[plugin.prepend_previewers]]
url = "*.tar*"
run = 'piper --format=url -- tar tf "$1"'
```

In this example, `--format=url` tells `piper` to parse the `tar` output as file URLs, so you'll be able to get a list of files with icons.

### Preview CSV with [`bat`](https://github.com/sharkdp/bat)

```toml
[[plugin.prepend_previewers]]
url = "*.csv"
run = 'piper -- bat -p --color=always "$1"'
```

Note that certain distributions might use a different name for `bat`, like Debian and Ubuntu uses `batcat` instead, so please adjust accordingly.

### Preview Markdown with [`glow`](https://github.com/charmbracelet/glow)

```toml
[[plugin.prepend_previewers]]
url = "*.md"
run = 'piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'
```

Note that there's [a bug in Glow v2.0](https://github.com/charmbracelet/glow/issues/440#issuecomment-2307992634) that causes slight color differences between tty and non-tty environments.

### Preview directory tree with [`eza`](https://github.com/eza-community/eza)

```toml
[[plugin.prepend_previewers]]
url = "*/"
run = 'piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'
```

### Preview the schema of a SQLite database

```toml
[[plugin.prepend_previewers]]
mime = "application/sqlite3"
run  = 'piper -- sqlite3 "$1" ".schema --indent"'
```

### Use [`hexyl`](https://github.com/sharkdp/hexyl) as fallback previewer

Yazi defaults to using [`file -bL "$1"`](https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/file.lua) if there's no matched previewer.

This example uses `hexyl` as a fallback previewer instead of `file`.

```toml
[[plugin.append_previewers]]
url = "*"
run = 'piper -- hexyl --border=none --terminal-width=$w "$1"'
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
