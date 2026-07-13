# vfs-demo.yazi

A plugin that demonstrates the new [custom VFS provider](https://github.com/sxyazi/yazi/pull/4118) (nightly only).

It doesn't do anything useful, but it can be used as a reference for developing your own VFS provider plugin.

> [!NOTE]
> Custom VFS is pretty experimental right now and the API may change.

## Installation

```sh
ya pkg add yazi-rs/plugins:vfs-demo
```

## Usage

```toml
# vfs.toml
[demo.test]
kind = "scope"
run  = "vfs-demo"
```

And run:

```sh
yazi demo://test//
```

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
