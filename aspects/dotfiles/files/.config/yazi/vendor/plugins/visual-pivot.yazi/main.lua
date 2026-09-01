---@sync entry

local function entry()
	local v = cx.active.mode.visual
	if v then
		local c = cx.active.current
		ya.emit("visual_arrow", { math.min(v.start, #c.files - 1) - c.cursor - v.wraps * #c.files })
	end
end

return { entry = entry }
