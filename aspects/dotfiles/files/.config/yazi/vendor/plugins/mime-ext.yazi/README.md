# mime-ext.yazi

A MIME type provider based on a file extension database, replacing the [builtin `file(1)`](https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/mime-local.lua) to speed up MIME type retrieval at the expense of accuracy.

See https://yazi-rs.github.io/docs/tips#make-yazi-even-faster for more information.

## Installation

```sh
ya pkg add yazi-rs/plugins:mime-ext
```

## Usage

Add this to your `~/.config/yazi/init.lua`:

```lua
require("mime-ext"):setup()
```

## Advanced

You can also customize it in your `~/.config/yazi/init.lua` with:

```lua
require("mime-ext.local"):setup {
	-- Expand the default filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the default extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- Empty the default filename and extension databases,
	-- use only the custom ones configured with `with_files` and `with_exts`
	custom_only = false,

	-- If the MIME type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime.local` plugin, which uses `file(1)`
	fallback_file1 = false,
}
```

## TODO

- Add more file types (PRs welcome!).
- Compress MIME type tables.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
