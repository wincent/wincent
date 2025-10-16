--- @since 25.5.31

local update = ya.sync(function(st, tags)
	for path, tag in pairs(tags) do
		st.tags[path] = #tag > 0 and tag or nil
	end
	-- TODO: remove this
	if ui.render then
		ui.render()
	else
		ya.render()
	end
end)

local selected_or_hovered = ya.sync(function()
	local tab, urls = cx.active, {}
	for _, u in pairs(tab.selected) do
		urls[#urls + 1] = u
	end
	if #urls == 0 and tab.current.hovered then
		urls[1] = tab.current.hovered.url
	end
	return urls
end)

local function setup(st, opts)
	st.tags = {}
	st.keys = opts.keys
	st.colors = opts.colors

	Linemode:children_add(function(self)
		local url = tostring(self._file.url)
		local spans = {}
		for _, tag in ipairs(st.tags[url] or {}) do
			if self._file.is_hovered then
				spans[#spans + 1] = ui.Span(" ●"):bg(st.colors[tag] or "reset")
			else
				spans[#spans + 1] = ui.Span(" ●"):fg(st.colors[tag] or "reset")
			end
		end
		return ui.Line(spans)
	end, 500)
end

local function fetch(_, job)
	local paths = {}
	for _, file in ipairs(job.files) do
		paths[#paths + 1] = tostring(file.url)
	end

	local output, err = Command("tag"):arg(paths):stdout(Command.PIPED):output()
	if not output then
		return true, Err("Cannot spawn `tag` command, error: %s", err)
	end

	local i, tags = 1, {}
	for line in output.stdout:gmatch("[^\r\n]+") do
		if i > #paths then
			break
		end
		tags[paths[i]] = tags[paths[i]] or {}

		local joint = line:match("\t(.+)$") or ""
		for s in joint:gmatch("[^,]+") do
			table.insert(tags[paths[i]], s)
		end
		i = i + 1
	end

	update(tags)
	return true
end

local cands = ya.sync(function(st)
	local t = {}
	for k, v in pairs(st.keys) do
		t[#t + 1] = { on = k, desc = v }
	end
	return t
end)

local function entry(self, job)
	assert(job.args[1] == "add" or job.args[1] == "remove", "Invalid action")
	ya.emit("escape", { visual = true })

	local cands = cands()
	local choice = ya.which { cands = cands }
	if not choice then
		return
	end

	local t = { job.args[1] == "remove" and "-r" or "-a", cands[choice].desc }
	local files = {}
	for _, url in ipairs(selected_or_hovered()) do
		t[#t + 1] = tostring(url)
		files[#files + 1] = { url = url }
	end

	local status = Command("tag"):arg(t):status()
	if status.success then
		fetch(self, { files = files })
	end
end

return { setup = setup, fetch = fetch, entry = entry }
