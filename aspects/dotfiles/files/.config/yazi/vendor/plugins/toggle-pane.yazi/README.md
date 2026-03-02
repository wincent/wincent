# toggle-pane.yazi

Toggle the show, hide, and maximize states for different panes: parent, current, and preview. It respects the user's [`ratio` settings](https://yazi-rs.github.io/docs/configuration/yazi#mgr.ratio)!

Assume the user's `ratio` is $$[A, B, C]$$, that is, $$\text{parent}=A, \text{current}=B, \text{preview}=C$$:

- `min-parent`: Toggles between $$0$$ and $$A$$ - the parent is either completely hidden or showed with width $$A$$.
- `max-parent`: Toggles between $$A$$ and $$\infty$$ - the parent is either showed with width $$A$$ or fills the entire screen.
- `min-current`: Toggles between $$0$$ and $$B$$ - the current is either completely hidden or showed with width $$B$$.
- `max-current`: Toggles between $$B$$ and $$\infty$$ - the current is either showed with width $$B$$ or fills the entire screen.
- `min-preview`: Toggles between $$0$$ and $$C$$ - the preview is either completely hidden or showed with width $$C$$.
- `max-preview`: Toggles between $$C$$ and $$\infty$$ - the preview is either showed with width $$C$$ or fills the entire screen.
- `reset`: Resets to the user's configured `ratio`.

## Installation

```sh
ya pkg add yazi-rs/plugins:toggle-pane
```

## Usage

Hide/Show preview:

```toml
# keymap.toml
[[mgr.prepend_keymap]]
on   = "T"
run  = "plugin toggle-pane min-preview"
desc = "Show or hide the preview pane"
```

Maximize/Restore preview:

```toml
# keymap.toml
[[mgr.prepend_keymap]]
on   = "T"
run  = "plugin toggle-pane max-preview"
desc = "Maximize or restore the preview pane"
```

You can replace `preview` with `current` or `parent` to toggle the other panes.

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other actions/plugins.

## Advanced

In addition to triggering the plugin with a keypress, you can also trigger it in your `init.lua` file:

```lua
if os.getenv("NVIM") then
	require("toggle-pane"):entry("min-preview")
end
```

In the example above, when it detects that you're [using Yazi in nvim](https://yazi-rs.github.io/docs/resources#vim), the preview is hidden by default — you can always press `T` (or any key you've bound) to show it again.

## Tips

This plugin only maximizes the "available preview area", without actually changing the content size.

This means that the appearance of your preview largely depends on the previewer you are using.
However, most previewers tend to make the most of the available space, so this usually isn't an issue.

For image previews, you may want to tune up the [`max_width`][max-width] and [`max_height`][max-height] options in your `yazi.toml`:

```toml
[preview]
# Change them to your desired values
max_width  = 1000
max_height = 1000
```

[max-width]: https://yazi-rs.github.io/docs/configuration/yazi/#preview.max_width
[max-height]: https://yazi-rs.github.io/docs/configuration/yazi/#preview.max_height

## License

This plugin is MIT-licensed. For more information, check the [LICENSE](LICENSE) file.
