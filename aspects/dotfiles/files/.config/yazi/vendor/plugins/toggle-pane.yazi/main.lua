--- @since 26.1.22
--- @sync entry

local function eq(other)
	local r = rt.mgr.ratio
	return other.parent == r.parent and other.current == r.current and other.preview == r.preview
end

local function get()
	local r = rt.mgr.ratio
	return { parent = r.parent, current = r.current, preview = r.preview }
end

local function set(new) rt.mgr.ratio = { new.parent, new.current, new.preview } end

local function entry(st, job)
	job = type(job) == "string" and { args = { job } } or job

	if not eq(st.new or {}) then
		st.new, st.old = nil, nil
	end
	local N, O = st.new or get(), st.old or get()

	local act, to = string.match(job.args[1] or "", "(.-)-(.+)")
	if act == "min" then
		N[to] = N[to] == O[to] and 0 or O[to]
	elseif act == "max" then
		local max = N[to] == 9999 and O[to] or 9999
		N.parent = N.parent == 9999 and O.parent or N.parent
		N.current = N.current == 9999 and O.current or N.current
		N.preview = N.preview == 9999 and O.preview or N.preview
		N[to] = max
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
