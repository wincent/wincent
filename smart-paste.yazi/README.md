# smart-paste.yazi

Paste files into the hovered directory or to the CWD if hovering over a file.

https://github.com/user-attachments/assets/b3f6348e-abbe-42fe-9a67-a96e68f11255

## Installation

```sh
ya pkg add yazi-rs/plugins:smart-paste
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = "p"
run  = "plugin smart-paste"
desc = "Paste into the hovered directory or CWD"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other commands/plugins.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
