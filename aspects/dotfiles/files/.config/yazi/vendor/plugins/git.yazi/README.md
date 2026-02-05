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
id  = "git"
url = "*"
run = "git"

[[plugin.prepend_fetchers]]
id  = "git"
url = "*/"
run = "git"
```

## Advanced

> [!NOTE]
> The following configuration must be put before `require("git"):setup()`

You can customize the [Style](https://yazi-rs.github.io/docs/plugins/layout#style) of the status sign with:

- `th.git.unknown` - status cannot/not yet determined
- `th.git.modified` - modified file
- `th.git.added` - added file
- `th.git.untracked` - untracked file
- `th.git.ignored` - ignored file
- `th.git.deleted` - deleted file
- `th.git.updated` - updated file
- `th.git.clean` - clean file

For example:

```lua
-- ~/.config/yazi/init.lua
th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()
```

You can also customize the text of the status sign with:

- `th.git.unknown_sign` - status cannot/not yet determined
- `th.git.modified_sign` - modified file
- `th.git.added_sign` - added file
- `th.git.untracked_sign` - untracked file
- `th.git.ignored_sign` - ignored file
- `th.git.deleted_sign` - deleted file
- `th.git.updated_sign` - updated file
- `th.git.clean_sign` - clean file

For example:

```lua
-- ~/.config/yazi/init.lua
th.git = th.git or {}
th.git.unknown_sign = " "
th.git.modified_sign = "M"
th.git.deleted_sign = "D"
th.git.clean_sign = "✔"
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
