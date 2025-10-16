> [!NOTE]
> The latest Yazi nightly build is required to use this plugin at the moment.

# zoom.yazi

Enlarge or shrink the preview image of a file, which is useful for magnifying small files for viewing.

Supported formats:

- Images - requires [ImageMagick](https://imagemagick.org/) (>= 7.1.1)

Note that, the maximum size of enlarged images is limited by the [`max_width`][max_width] and [`max_height`][max_height] configuration options, so you may need to increase them as needed.

https://github.com/user-attachments/assets/b28912b1-da63-43d3-a21f-b9e6767ed4a9

[max_width]: https://yazi-rs.github.io/docs/configuration/yazi#preview.max_width
[max_height]: https://yazi-rs.github.io/docs/configuration/yazi#preview.max_height

## Installation

```sh
ya pkg add yazi-rs/plugins:zoom
```

## Usage

```toml
# keymap.toml
[[mgr.prepend_keymap]]
on   = "+"
run  = "plugin zoom 1"
desc = "Zoom in hovered file"

[[mgr.prepend_keymap]]
on   = "-"
run  = "plugin zoom -1"
desc = "Zoom out hovered file"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other commands/plugins.

## Advanced

If you want to apply a default zoom parameter to image previews, you can specify it while setting this plugin up as a custom previewer, for example:

```toml
[[plugin.prepend_previewers]]
mime = "image/{jpeg,png,webp}"
run  = "zoom 5"
```

## TODO

- [ ] Support more file types (e.g., videos, PDFs), PRs welcome!

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
