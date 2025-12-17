--- @since 25.5.31

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function fail(s, ...)
	ya.notify {
		title = "Chmod",
		content = string.format(s, ...),
		level = "error",
		timeout = 5,
	}
end

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify { title = "Chmod", content = "No file selected", level = "warn", timeout = 5 }
		end

		local value, event = ya.input {
			title = "Chmod:",
			pos = { "top-center", y = 3, w = 40 },
			position = { "top-center", y = 3, w = 40 }, -- TODO: remove
		}
		if event ~= 1 then
			return
		end

		local output, err = Command("chmod"):arg(value):arg(urls):stderr(Command.PIPED):output()
		if not output then
			fail("Failed to run chmod: %s", err)
		elseif not output.status.success then
			fail("Chmod failed with stderr:\n%s", output.stderr:gsub("^chmod:%s*", ""))
		end
	end,
}
