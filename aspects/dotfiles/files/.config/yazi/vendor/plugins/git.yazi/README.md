# git.yazi

Show the status of Git file changes as linemode in the file list.

https://github.com/user-attachments/assets/34976be9-a871-4ffe-9d5a-c4cdd0bf4576

## Installation

```sh
ya pkg add yazi-rs/plugins:git
```

## Setup

Add the following to your `~/.config/yazi/init.lua`:

```lua
require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}
```

And register it as fetchers in your `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_fetchers]]
id    = "git" # Remove if Yazi > v26.1.22
url   = "*"
run   = "git"
group = "git"

[[plugin.prepend_fetchers]]
id    = "git" # Remove if Yazi > v26.1.22
url   = "*/"
run   = "git"
group = "git"
```

## Advanced

You can customize the [Style](https://yazi-rs.github.io/docs/configuration/theme#types.style) of the status sign with:

- `[git].unknown` - status cannot/not yet determined
- `[git].modified` - modified file
- `[git].added` - added file
- `[git].untracked` - untracked file
- `[git].ignored` - ignored file
- `[git].deleted` - deleted file
- `[git].updated` - updated file
- `[git].clean` - clean file

For example:

```toml
# theme.toml / flavor.toml
[git]
modified = { fg = "blue" }
deleted  = { fg = "red", bold = true }
```

You can also customize the text of the status sign with:

- `[git].unknown_sign` - status cannot/not yet determined
- `[git].modified_sign` - modified file
- `[git].added_sign` - added file
- `[git].untracked_sign` - untracked file
- `[git].ignored_sign` - ignored file
- `[git].deleted_sign` - deleted file
- `[git].updated_sign` - updated file
- `[git].clean_sign` - clean file

For example:

```toml
# theme.toml / flavor.toml
[git]
unknown_sign  = " "
modified_sign = "M"
deleted_sign  = "D"
clean_sign    = "✔"
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
