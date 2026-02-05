--- @since 25.12.29

local toggle_ui = ya.sync(function(self)
	if self.children then
		Modal:children_remove(self.children)
		self.children = nil
	else
		self.children = Modal:children_add(self, 10)
	end
	ui.render()
end)

local subscribe = ya.sync(function(self)
	ps.unsub("mount")
	ps.sub("mount", function() ya.emit("plugin", { self._id, "refresh" }) end)
end)

local update_partitions = ya.sync(function(self, partitions)
	self.partitions = partitions
	self.cursor = math.max(0, math.min(self.cursor or 0, #self.partitions - 1))
	ui.render()
end)

local active_partition = ya.sync(function(self) return self.partitions[self.cursor + 1] end)

local update_cursor = ya.sync(function(self, cursor)
	if #self.partitions == 0 then
		self.cursor = 0
	else
		self.cursor = ya.clamp(0, self.cursor + cursor, #self.partitions - 1)
	end
	ui.render()
end)

local M = {
	keys = {
		{ on = "q", run = "quit" },
		{ on = "<Esc>", run = "quit" },
		{ on = "<Enter>", run = { "enter", "quit" } },

		{ on = "k", run = "up" },
		{ on = "j", run = "down" },
		{ on = "l", run = { "enter", "quit" } },

		{ on = "<Up>", run = "up" },
		{ on = "<Down>", run = "down" },
		{ on = "<Right>", run = { "enter", "quit" } },

		{ on = "m", run = "mount" },
		{ on = "u", run = "unmount" },
		{ on = "e", run = "eject" },
	},
}

function M:new(area)
	self:layout(area)
	return self
end

function M:layout(area)
	local chunks = ui.Layout()
		:constraints({
			ui.Constraint.Percentage(10),
			ui.Constraint.Percentage(80),
			ui.Constraint.Percentage(10),
		})
		:split(area)

	local chunks = ui.Layout()
		:direction(ui.Layout.HORIZONTAL)
		:constraints({
			ui.Constraint.Percentage(10),
			ui.Constraint.Percentage(80),
			ui.Constraint.Percentage(10),
		})
		:split(chunks[2])

	self._area = chunks[2]
end

function M:entry(job)
	if job.args[1] == "refresh" then
		return update_partitions(self.obtain())
	end

	toggle_ui()
	update_partitions(self.obtain())
	subscribe()

	local tx1, rx1 = ya.chan("mpsc")
	local tx2, rx2 = ya.chan("mpsc")
	function producer()
		while true do
			local cand = self.keys[ya.which { cands = self.keys, silent = true }] or { run = {} }
			for _, r in ipairs(type(cand.run) == "table" and cand.run or { cand.run }) do
				tx1:send(r)
				if r == "quit" then
					toggle_ui()
					return
				end
			end
		end
	end

	function consumer1()
		repeat
			local run = rx1:recv()
			if run == "quit" then
				tx2:send(run)
				break
			elseif run == "up" then
				update_cursor(-1)
			elseif run == "down" then
				update_cursor(1)
			elseif run == "enter" then
				local active = active_partition()
				if active and active.dist then
					ya.emit("cd", { active.dist })
				end
			else
				tx2:send(run)
			end
		until not run
	end

	function consumer2()
		repeat
			local run = rx2:recv()
			if run == "quit" then
				break
			elseif run == "mount" then
				require(".cross").operate("mount", active_partition())
			elseif run == "unmount" then
				require(".cross").operate("unmount", active_partition())
			elseif run == "eject" then
				require(".cross").operate("eject", active_partition())
			end
		until not run
	end

	ya.join(producer, consumer1, consumer2)
end

function M:reflow() return { self } end

function M:redraw()
	local rows = {}
	for _, p in ipairs(self.partitions or {}) do
		if not p.sub then
			rows[#rows + 1] = ui.Row { p.main }
		elseif p.sub == "" then
			rows[#rows + 1] = ui.Row { p.main, p.label or "", p.dist or "", p.fstype or "" }
		else
			rows[#rows + 1] = ui.Row { "  " .. p.sub, p.label or "", p.dist or "", p.fstype or "" }
		end
	end

	return {
		ui.Clear(self._area),
		ui.Border(ui.Edge.ALL)
			:area(self._area)
			:type(ui.Border.ROUNDED)
			:style(ui.Style():fg("blue"))
			:title(ui.Line("Mount"):align(ui.Align.CENTER)),
		ui.Table(rows)
			:area(self._area:pad(ui.Pad(1, 2, 1, 2)))
			:header(ui.Row({ "Src", "Label", "Dist", "FSType" }):style(ui.Style():bold()))
			:row(self.cursor)
			:row_style(ui.Style():fg("blue"):underline())
			:widths {
				ui.Constraint.Length(20),
				ui.Constraint.Length(20),
				ui.Constraint.Percentage(70),
				ui.Constraint.Length(10),
			},
	}
end

function M.obtain()
	local tbl = {}
	local last
	for _, p in ipairs(fs.partitions()) do
		local main, sub = M.split(p.src)
		if main and last ~= main then
			if p.src == main then
				last, p.main, p.sub, tbl[#tbl + 1] = p.src, p.src, "", p
			else
				last, tbl[#tbl + 1] = main, { src = main, main = main, sub = "" }
			end
		end
		if sub then
			if tbl[#tbl].sub == "" and tbl[#tbl].main == main then
				tbl[#tbl].sub = nil
			end
			p.main, p.sub, tbl[#tbl + 1] = main, sub, p
		end
	end
	table.sort(M.fillin(tbl), function(a, b)
		if a.main == b.main then
			return (a.sub or "") < (b.sub or "")
		else
			return a.main > b.main
		end
	end)
	return tbl
end

function M.split(src)
	local pats = {
		{ "^/dev/sd[a-z]", "%d+$" }, -- /dev/sda1
		{ "^/dev/nvme%d+n%d+", "p%d+$" }, -- /dev/nvme0n1p1
		{ "^/dev/mmcblk%d+", "p%d+$" }, -- /dev/mmcblk0p1
		{ "^/dev/disk%d+", ".+$" }, -- /dev/disk1s1
		{ "^/dev/sr%d+", ".+$" }, -- /dev/sr0
	}
	for _, p in ipairs(pats) do
		local main = src:match(p[1])
		if main then
			return main, src:sub(#main + 1):match(p[2])
		end
	end
end

function M.fillin(tbl)
	if ya.target_os() ~= "linux" then
		return tbl
	end

	local sources, indices = {}, {}
	for i, p in ipairs(tbl) do
		if p.sub and not p.fstype then
			sources[#sources + 1], indices[p.src] = p.src, i
		end
	end
	if #sources == 0 then
		return tbl
	end

	local output, err = Command("lsblk"):arg({ "-p", "-o", "name,fstype", "-J" }):arg(sources):output()
	if err then
		ya.dbg("Failed to fetch filesystem types for unmounted partitions: " .. err)
		return tbl
	end

	local t = ya.json_decode(output and output.stdout or "")
	for _, p in ipairs(t and t.blockdevices or {}) do
		tbl[indices[p.name]].fstype = p.fstype
	end
	return tbl
end

function M:click() end

function M:scroll() end

function M:touch() end

return M
