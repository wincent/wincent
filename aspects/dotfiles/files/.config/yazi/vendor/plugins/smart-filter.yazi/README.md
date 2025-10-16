# smart-filter.yazi

A Yazi plugin that makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting.

https://github.com/yazi-rs/plugins/assets/17523360/72aaf117-1378-4f7e-93ba-d425a79deac5

## Installation

```sh
ya pkg add yazi-rs/plugins:smart-filter
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = "F"
run  = "plugin smart-filter"
desc = "Smart filter"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other commands/plugins.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
