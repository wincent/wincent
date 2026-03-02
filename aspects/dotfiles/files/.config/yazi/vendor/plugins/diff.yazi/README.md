# diff.yazi

Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard.

https://github.com/yazi-rs/plugins/assets/17523360/eff5e949-386a-44ea-82f9-4cb4a2c37aad

## Installation

```sh
ya pkg add yazi-rs/plugins:diff
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = "<C-d>"
run  = "plugin diff"
desc = "Diff the selected with the hovered file"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other actions/plugins.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
