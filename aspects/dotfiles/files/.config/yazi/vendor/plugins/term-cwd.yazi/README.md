# term-cwd.yazi

Inform terminal about current directory change by sending OSC code.

## Installation

```sh
ya pkg add yazi-rs/plugins:term-cwd
```

## Usage

Add this to your `init.lua` to enable the plugin:

```lua
require("term-cwd"):setup()
```

Or you can customize the OSC code during setup:

```lua
require("term-cwd"):setup {
	-- Available values: OSC7 (default on unix), OSC9_9 (default on windows)
	osc = "OSC7",
}
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
