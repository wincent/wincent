--- @since 25.2.7

local function setup()
	local old_layout = Tab.layout

	Status.redraw = function() return {} end
	Tab.layout = function(self, ...)
		self._area = ui.Rect { x = self._area.x, y = self._area.y, w = self._area.w, h = self._area.h + 1 }
		return old_layout(self, ...)
	end
end

return { setup = setup }
