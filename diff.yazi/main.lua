--- @since 25.2.7

local function info(content)
	return ya.notify {
		title = "Diff",
		content = content,
		timeout = 5,
	}
end

local selected_url = ya.sync(function()
	for _, u in pairs(cx.active.selected) do
		return u
	end
end)

local hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url
end)

return {
	entry = function()
		local a, b = selected_url(), hovered_url()
		if not a then
			return info("No file selected")
		elseif not b then
			return info("No file hovered")
		end

		local output, err = Command("diff"):arg("-Naur"):arg(tostring(a)):arg(tostring(b)):output()
		if not output then
			return info("Failed to run diff, error: " .. err)
		elseif output.stdout == "" then
			return info("No differences found")
		end

		ya.clipboard(output.stdout)
		info("Diff copied to clipboard")
	end,
}
