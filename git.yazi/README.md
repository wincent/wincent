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
require("git"):setup()
```

And register it as fetchers in your `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_fetchers]]
id   = "git"
name = "*"
run  = "git"

[[plugin.prepend_fetchers]]
id   = "git"
name = "*/"
run  = "git"
```

## Advanced

> [!NOTE]  
> The following configuration must be put before `require("git"):setup()`

You can customize the [Style](https://yazi-rs.github.io/docs/plugins/layout#style) of the status sign with:

- `th.git.modified`
- `th.git.added`
- `th.git.untracked`
- `th.git.ignored`
- `th.git.deleted`
- `th.git.updated`

For example:

```lua
-- ~/.config/yazi/init.lua
th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()
```

You can also customize the text of the status sign with:

- `th.git.modified_sign`
- `th.git.added_sign`
- `th.git.untracked_sign`
- `th.git.ignored_sign`
- `th.git.deleted_sign`
- `th.git.updated_sign`

For example:

```lua
-- ~/.config/yazi/init.lua
th.git = th.git or {}
th.git.modified_sign = "M"
th.git.deleted_sign = "D"
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
