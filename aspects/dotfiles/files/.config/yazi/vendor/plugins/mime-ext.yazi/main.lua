local M = {}

function M:setup(opts)
	ya.notify {
		title = "Deprecated fetcher",
		content = "`mime-ext` has been deprecated in favor of `mime-ext.local` and `mime-ext.remote`, please use the new names instead in your `yazi.toml`.\n\nSee the README.md for more info: https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi#usage",
		timeout = 15,
		level = "warn",
	}
	return require(".local"):setup(opts)
end

function M:fetch(job)
	ya.notify {
		title = "Deprecated fetcher",
		content = "`mime-ext` has been deprecated in favor of `mime-ext.local` and `mime-ext.remote`, please use the new names instead in your `yazi.toml`.\n\nSee the README.md for more info: https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi#usage",
		timeout = 15,
		level = "warn",
	}
	return require(".local"):fetch(job)
end

return M
