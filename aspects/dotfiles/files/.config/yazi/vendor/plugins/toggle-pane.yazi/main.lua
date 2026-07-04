--- @since 26.1.22
--- @sync entry

local PANE = { parent = 1, current = 2, preview = 3 }

local function eq(other)
	local r = rt.mgr.ratio
	if r[1] then
		return other[1] == r[1] and other[2] == r[2] and other[3] == r[3]
	else -- TODO: remove
		return other[1] == r.parent and other[2] == r.current and other[3] == r.preview
	end
end

local function get()
	local r = rt.mgr.ratio
	if r[1] then
		return { r[1], r[2], r[3] }
	else -- TODO: remove
		return { r.parent, r.current, r.preview }
	end
end

local function set(new) rt.mgr.ratio = { new[1], new[2], new[3] } end

local function entry(st, job)
	job = type(job) == "string" and { args = { job } } or job

	if not eq(st.new or {}) then
		st.new, st.old = nil, nil
	end
	local N, O = st.new or get(), st.old or get()

	local act, to = string.match(job.args[1] or "", "(.-)-(.+)")
	local i = PANE[to]
	if act == "min" then
		N[i] = N[i] == O[i] and 0 or O[i]
	elseif act == "max" then
		local max = N[i] == 9999 and O[i] or 9999
		N[1] = N[1] == 9999 and O[1] or N[1]
		N[2] = N[2] == 9999 and O[2] or N[2]
		N[3] = N[3] == 9999 and O[3] or N[3]
		N[i] = max
	end

	if act then
		st.new, st.old = N, O
	else
		N, st.new, st.old = O, nil, nil
	end

	set(N)
	ya.emit("app:resize", {})
end

return { entry = entry }
