# mount.yazi

A mount manager for Yazi, providing disk mount, unmount, and eject functionality.

Supported platforms:

- Linux with [`udisksctl`](https://github.com/storaged-project/udisks), `lsblk` and `eject` both provided by [`util-linux`](https://github.com/util-linux/util-linux)
- macOS with `diskutil`, which is pre-installed

https://github.com/user-attachments/assets/c6f780ab-458b-420f-85cf-2fc45fcfe3a2

## Installation

```sh
ya pkg add yazi-rs/plugins:mount
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on  = "M"
run = "plugin mount"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other commands/plugins.

## Actions

| Key binding  | Alternate key | Action                |
| ------------ | ------------- | --------------------- |
| <kbd>q</kbd> | -             | Quit the plugin       |
| <kbd>k</kbd> | <kbd>↑</kbd>  | Move up               |
| <kbd>j</kbd> | <kbd>↓</kbd>  | Move down             |
| <kbd>l</kbd> | <kbd>→</kbd>  | Enter the mount point |
| <kbd>m</kbd> | -             | Mount the partition   |
| <kbd>u</kbd> | -             | Unmount the partition |
| <kbd>e</kbd> | -             | Eject the disk        |

## TODO

- Custom keybindings
- Windows support (I don't use Windows myself, PRs welcome!)
- Support mount, unmount, and eject the entire disk

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
