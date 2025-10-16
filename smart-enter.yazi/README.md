# smart-enter.yazi

[`Open`][open] files or [`enter`][enter] directories all in one key!

## Installation

```sh
ya pkg add yazi-rs/plugins:smart-enter
```

## Usage

Bind your <kbd>l</kbd> key to the plugin, in your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = "l"
run  = "plugin smart-enter"
desc = "Enter the child directory, or open the file"
```

## Advanced

By default, `--hovered` is passed to the [`open`][open] command, make the behavior consistent with [`enter`][enter] avoiding accidental triggers,
which means both will only target the currently hovered file.

If you still want `open` to target multiple selected files, add this to your `~/.config/yazi/init.lua`:

```lua
require("smart-enter"):setup {
	open_multi = true,
}
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.

[open]: https://yazi-rs.github.io/docs/configuration/keymap/#mgr.open
[enter]: https://yazi-rs.github.io/docs/configuration/keymap/#mgr.enter
