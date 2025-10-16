--- @since 25.6.11

local get = ya.sync(function(st, url) return st.last == url and st.level end)

local save = ya.sync(function(st, url, new)
	local h = cx.active.current.hovered
	if h and h.url == url then
		st.last, st.level = url, new
		return true
	end
end)

local lock = ya.sync(function(st, url, old, new)
	if st.last == url and st.level == old then
		st.level = new
		return true
	end
end)

local move = ya.sync(function(st)
	local h = cx.active.current.hovered
	if not h then
		return
	end

	if st.last ~= h.url then
		st.last, st.level = Url(h.url), 0
	end

	return { url = h.url, level = st.level }
end)

local function end_(job, err)
	if not job.old_level then
		ya.preview_widget(job, err and ui.Text(err):area(job.area):wrap(ui.Wrap.YES))
	elseif err then
		ya.notify { title = "Zoom", content = tostring(err), timeout = 5, level = "error" }
	end
end

local function canvas(area)
	local cw, ch = rt.term.cell_size()
	if not cw then
		return rt.preview.max_width, rt.preview.max_height
	end

	return math.min(rt.preview.max_width, math.floor(area.w * cw)),
		math.min(rt.preview.max_height, math.floor(area.h * ch))
end

local function peek(_, job)
	local url = job.file.url
	local info, err = ya.image_info(url)
	if not info then
		return end_(job, Err("Failed to get image info: %s", err))
	end

	local level = ya.clamp(-10, job.new_level or get(Url(url)) or tonumber(job.args[1]) or 0, 10)
	local sync = function()
		if job.old_level then
			return lock(url, job.old_level, level)
		else
			return save(url, level)
		end
	end

	local max_w, max_h = canvas(job.area)
	local min_w, min_h = math.min(max_w, info.w), math.min(max_h, info.h)
	local new_w = min_w + math.floor(min_w * level * 0.1)
	local new_h = min_h + math.floor(min_h * level * 0.1)
	if new_w > max_w or new_h > max_h then
		if job.old_level then
			return sync() -- Image larger than available preview area after zooming
		else
			new_w, new_h = max_w, max_h -- Run as a previewer, render the image anyway
		end
	end

	local tmp = os.tmpname()
	-- stylua: ignore
	local status, err = Command("magick"):arg {
		tostring(url),
		"-auto-orient", "-strip",
		"-sample", string.format("%dx%d", new_w, new_h),
		"-quality", rt.preview.image_quality,
		string.format("JPG:%s", tmp),
	}:status()

	if not status then
		end_(job, Err("Failed to run `magick` command: %s", err))
	elseif not status.success then
		end_(job, Err("`magick` command exited with error code %d", status.code))
	elseif sync() then
		ya.image_show(Url(tmp), job.area)
	end
	end_(job)
end

local function entry(self, job)
	local st = move()
	if not st then
		return
	end

	local motion = tonumber(job.args[1]) or 0
	local new = ya.clamp(-10, st.level + motion, 10)
	if new ~= st.level then
		peek(self, {
			area = ui.area("preview"),
			args = {},
			file = { url = st.url }, -- FIXME: use `File` instead of a dummy file
			skip = 0,
			new_level = new,
			old_level = st.level,
		})
	end
end

return { peek = peek, entry = entry }
