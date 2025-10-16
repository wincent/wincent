# types.yazi

Type definitions for Yazi's Lua API, empowering an efficient plugin development experience.

## Installation

```sh
ya pkg add yazi-rs/plugins:types
```

## Usage

Create a `.luarc.json` file in your project root:

<!-- prettier-ignore -->
```json5
{
  "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
  "runtime.version": "Lua 5.4",
  "workspace.library": [
    // You may need to change the path to your local plugin directory
    "~/.config/yazi/plugins/types.yazi/",
  ],
}
```

See https://luals.github.io/wiki/configuration/ for more information on how to configure LuaLS.

## Contributing

All type definitions are automatically generated using [typegen.js][typegen.js] based on the latest [plugin documentation][plugin documentation],
so contributions should be made in the [`yazi-rs.github.io` repository][doc-repo].

[typegen.js]: https://github.com/yazi-rs/yazi-rs.github.io/blob/main/scripts/typegen.js
[plugin documentation]: https://yazi-rs.github.io/docs/plugins/overview
[doc-repo]: https://github.com/yazi-rs/yazi-rs.github.io

## License

This plugin is MIT-licensed. For more information, check the [LICENSE](LICENSE) file.
