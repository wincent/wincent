--- @since 26.8.15

local function setup()
	for i, f in pairs(rt.plugin.fetchers:match()) do
		local _, name = pcall(function() return f.run.name end) -- TODO: remove
		name = name or f.run

		-- TODO: use `:update()` instead of `:remove()` and `:insert()`
		if name == "mime.local" then
			rt.plugin.fetchers:remove { id = f.id }
			rt.plugin.fetchers:insert(i, { url = "local://*", run = "mime-ext.local", prio = "high", group = "mime" })
		elseif name == "mime.remote" then
			rt.plugin.fetchers:remove { id = f.id }
			rt.plugin.fetchers:insert(i, { url = "remote://*", run = "mime-ext.remote", prio = "high", group = "mime" })
		end
	end
end

return { setup = setup }
