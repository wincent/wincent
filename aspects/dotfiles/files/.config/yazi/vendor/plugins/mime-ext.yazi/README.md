# mime-ext.yazi

A mime-type provider based on a file extension database, replacing the [builtin `file(1)`](https://github.com/sxyazi/yazi/blob/main/yazi-plugin/preset/plugins/mime.lua) to speed up mime-type retrieval at the expense of accuracy.

See https://yazi-rs.github.io/docs/tips#make-yazi-even-faster for more information.

## Installation

```sh
ya pkg add yazi-rs/plugins:mime-ext
```

## Usage

Add this to your `~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_fetchers]]
id   = "mime"
name = "*"
run  = "mime-ext"
prio = "high"
```

## Advanced

You can also customize it in your `~/.config/yazi/init.lua` with:

```lua
require("mime-ext"):setup {
	-- Expand the existing filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the existing extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- If the mime-type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime` plugin, which uses `file(1)`
	fallback_file1 = false,
}
```

## TODO

- Add more file types (PRs welcome!).
- Compress mime-type tables.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
