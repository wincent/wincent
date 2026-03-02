# mactag.yazi

Bring macOS's awesome tagging feature to Yazi! The plugin it's only available for macOS just like the name says.

Authors: [@AnirudhG07](https://github.com/AnirudhG07), and [@sxyazi](https://github.com/sxyazi)

https://github.com/user-attachments/assets/7f26dc6d-67a5-4a85-a99e-4671ece9ae56

## Installation

Install the plugin itself, and [jdberry/tag](https://github.com/jdberry/tag) used to tag files:

```sh
ya pkg add yazi-rs/plugins:mactag
brew update && brew install tag
```

## Setup

Add the following to your `~/.config/yazi/init.lua`:

```lua
require("mactag"):setup {
	-- Keys used to add or remove tags
	keys = {
		r = "Red",
		o = "Orange",
		y = "Yellow",
		g = "Green",
		b = "Blue",
		p = "Purple",
	},
	-- Colors used to display tags
	colors = {
		Red    = "#ee7b70",
		Orange = "#f5bd5c",
		Yellow = "#fbe764",
		Green  = "#91fc87",
		Blue   = "#5fa3f8",
		Purple = "#cb88f8",
	},
	-- Order of the color circle showing in the line mode
	order = 500,
}
```

And register it as fetchers in your `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_fetchers]]
id  = "mactag"
url = "*"
run = "mactag"

[[plugin.prepend_fetchers]]
id  = "mactag"
url = "*/"
run = "mactag"
```

## Usage

Besides displaying tags attached to files, you can also add or remove tags within Yazi using this plugin.

Add following keybindings to your `~/.config/yazi/keymap.toml` to enable it:

```toml
[[mgr.prepend_keymap]]
on   = [ "b", "a" ]
run  = "plugin mactag add"
desc = "Tag selected files"

[[mgr.prepend_keymap]]
on   = [ "b", "r" ]
run  = "plugin mactag remove"
desc = "Untag selected files"
```

Note that, the keybindings above are just examples, please tune them up as needed to ensure they don't conflict with your other actions/plugins.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
