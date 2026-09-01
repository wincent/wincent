--- @since 26.8.15

local function setup(_, opts)
	local type = opts and opts.type or ui.Border.ROUNDED
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
			ui.Border(ui.Edge.ALL):area(c[2]):type(type):style(style),
			ui.Border(ui.Edge.ALL):area(self._area):type(type):style(style):merge(),
		})

		old_build(self, ...)
	end
end

return { setup = setup }
