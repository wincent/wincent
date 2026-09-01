--- @since 26.8.15

local selected_or_hovered = ya.sync(function()
	local tab, urls, paths = cx.active, {}, {}
	for i, f in pairs(tab.selected) do
		urls[i], paths[i] = f.url, tostring(f.path)
	end
	if #paths == 0 and tab.current.hovered then
		urls[1], paths[1] = tab.current.hovered.url, tostring(tab.current.hovered.path)
	end
	return urls, paths
end)

local function fail(s, ...)
	ya.notify {
		title = "Chmod",
		content = string.format(s, ...),
		level = "error",
		timeout = 5,
	}
end

local function report(urls)
	local ops = {}
	for _, url in ipairs(urls) do
		local file = fs.file(url)
		if file then
			ops[url.parent] = ops[url.parent] or {}
			ops[url.parent][url.key] = file
		end
	end
	for parent, files in pairs(ops) do
		ya.emit("update_files", {
			op = fs.op("upsert", { url = parent, files = files }),
		})
	end
end

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls, paths = selected_or_hovered()
		if #paths == 0 then
			return ya.notify { title = "Chmod", content = "No file selected", level = "warn", timeout = 5 }
		end

		local value, event = ya.input {
			title = "Chmod:",
			pos = { "top-center", y = 3, w = 40 },
		}
		if event ~= 1 then
			return
		end

		local output, err = Command("chmod"):arg(value):arg(paths):output()
		if not output then
			fail("Failed to run chmod: %s", err)
		elseif output.status.success then
			pcall(report, urls) -- TODO: remove `pcall`
		else
			fail("Chmod failed with stderr:\n%s", output.stderr:gsub("^chmod:%s*", ""))
		end
	end,
}
