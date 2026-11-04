--- @since 26.8.15

-- TODO: remove
local function set(border, opts)
	local type, set
	opts = opts or {}
	if opts.set then
		type = opts.set == "rounded" and ui.Border.ROUNDED or ui.Border.PLAIN
		set = opts.set
	elseif opts.type then
		ya.notify {
			title = "full-border.yazi",
			content = "The `type` option in `setup()` is deprecated, use the new `set` option instead.\n\nCheck the README.md of `full-border.yazi` for more details: https://github.com/yazi-rs/plugins/tree/main/full-border.yazi",
			timeout = 10,
			level = "warn",
		}
		type = opts.type == 1 and ui.Border.ROUNDED or ui.Border.PLAIN
		set = opts.type == 1 and "rounded" or "plain"
	else
		type = ui.Border.ROUNDED
		set = "rounded"
	end

	if th.input.border_set then
		border:set(set)
	else
		border:type(type)
	end
	return border
end

local function setup(_, opts)
	-- local set = opts and opts.set or "rounded"
	local old_build = Tab.build

	Tab.build = function(self, ...)
		local c = self._chunks
		self._chunks = {
			c[1]:pad(ui.Pad.y(1)),
			c[2]:pad(ui.Pad.y(1)),
			c[3]:pad(ui.Pad.y(1)),
		}

		local style = th.mgr.border_style
		self._base = ya.list_merge(self._base or {}, {
			set(ui.Border(ui.Edge.ALL):area(c[2]), opts):style(style),
			set(ui.Border(ui.Edge.ALL):area(self._area), opts):style(style):merge(),
		})

		old_build(self, ...)
	end
end

return { setup = setup }
