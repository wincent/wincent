# sudo-demo.yazi

Just an example showing how to use `sudo` in a Yazi plugin, and the plugin itself doesn't offer any features beyond logging a message.

## Installation

```sh
ya pkg add yazi-rs/plugins:sudo-demo
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on  = "<C-t>"
run = "plugin sudo-demo"
```

Press <kbd>Ctrl</kbd> + <kbd>t</kbd> to run the plugin, you should [see a message in the log](https://yazi-rs.github.io/docs/plugins/overview#logging).

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
