# rclone.yazi

Manage [100+ remote file services](https://rclone.org/#providers) supported by Rclone within Yazi.

Note that this plugin is currently experimental and requires Yazi nightly at the moment, if you run into any issues, please file a bug report.

## Installation

```sh
ya pkg add yazi-rs/plugins:rclone
```

## Usage

Include the following in your `vfs.toml`:

```toml
[rclone.test]
kind         = "scope"
run          = "rclone"
root         = "/"
backend.type = "webdav"
backend.url  = "https://my-domain.com/"
backend.user = "yazi"
backend.pass = "fake-password"
```

Then launch Yazi with `yazi rclone://test` to manage files located at `my-domain.com` via the WebDAV protocol.

Here `backend.type = "webdav"` indicates that the WebDAV backend is being used, and all properties under `backend.` other than `type` are the parameters required to connect to that backend. For more available WebDAV parameters, see https://rclone.org/webdav/#standard-options

Similarly, you can change `type` to any other backend supported by Rclone (Amazon S3, OneDrive, Backblaze B2, etc.) to access different cloud services.

## Tips

If you already have a working rclone remote configured, run `rclone config dump` to see its fields and copy the relevant ones under `backend.`.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
