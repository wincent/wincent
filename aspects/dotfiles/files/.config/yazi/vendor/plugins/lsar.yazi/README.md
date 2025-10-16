# lsar.yazi

Previewing archive contents with `lsar`, which is something you might not want to use anyway.

It was the default archive previewer before Yazi v0.3, and after then, it was replaced with a faster and more efficient `7zip` previewer.

This plugin is here just in case you're still interested in the old behavior,
but we strongly discourage using it unless you encounter some issues with `7zip` when previewing CJK characters - `lsar` usually does a better job recognizing these characters.

## Installation

```sh
ya pkg add yazi-rs/plugins:lsar
```

## Usage

Add this to your `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_previewers]]
mime = "application/{,g}zip"
run  = "lsar"

[[plugin.prepend_previewers]]
mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}"
run  = "lsar"
```

Make sure you have `unar` installed, and have `lsar` in your `$PATH`. You can install it with:

```sh
# Arch Linux
sudo pacman -S unarchiver
# macOS
brew install unar
# Windows
scoop install unar
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
