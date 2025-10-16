# vcs-files.yazi

Show Git file changes in Yazi.

https://github.com/user-attachments/assets/465b801b-3516-4f57-be09-8405da21e34d

## Installation

```sh
ya pkg add yazi-rs/plugins:vcs-files
```

## Usage

```toml
# keymap.toml
[[mgr.prepend_keymap]]
on   = [ "g", "c" ]
run  = "plugin vcs-files"
desc = "Show Git file changes"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other commands/plugins.

## TODO

- [ ] Add support for other VCS (e.g. Mercurial, Subversion)

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
