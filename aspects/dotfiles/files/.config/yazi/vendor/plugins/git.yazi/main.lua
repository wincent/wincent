--- @since 25.5.31

local WINDOWS = ya.target_family() == "windows"

-- The code of supported git status,
-- also used to determine which status to show for directories when they contain different statuses
-- see `bubble_up`
---@enum CODES
local CODES = {
	excluded = 100, -- ignored directory
	ignored = 6, -- ignored file
	untracked = 5,
	modified = 4,
	added = 3,
	deleted = 2,
	updated = 1,
	unknown = 0,
}

local PATTERNS = {
	{ "!$", CODES.ignored },
	{ "?$", CODES.untracked },
	{ "[MT]", CODES.modified },
	{ "[AC]", CODES.added },
	{ "D", CODES.deleted },
	{ "U", CODES.updated },
	{ "[AD][AD]", CODES.updated },
}

---@param line string
---@return CODES, string
local function match(line)
	local signs = line:sub(1, 2)
	for _, p in ipairs(PATTERNS) do
		local path, pattern, code = nil, p[1], p[2]
		if signs:find(pattern) then
			path = line:sub(4, 4) == '"' and line:sub(5, -2) or line:sub(4)
			path = WINDOWS and path:gsub("/", "\\") or path
		end
		if not path then
		elseif path:find("[/\\]$") then
			-- Mark the ignored directory as `excluded`, so we can process it further within `propagate_down`
			return code == CODES.ignored and CODES.excluded or code, path:sub(1, -2)
		else
			return code, path
		end
		---@diagnostic disable-next-line: missing-return
	end
end

---@param cwd Url
---@return string?
local function root(cwd)
	local is_worktree = function(url)
		local file, head = io.open(tostring(url)), nil
		if file then
			head = file:read(8)
			file:close()
		end
		return head == "gitdir: "
	end

	repeat
		local next = cwd:join(".git")
		local cha = fs.cha(next)
		if cha and (cha.is_dir or is_worktree(next)) then
			return tostring(cwd)
		end
		cwd = cwd.parent
	until not cwd
end

---@param changed Changes
---@return Changes
local function bubble_up(changed)
	local new, empty = {}, Url("")
	for path, code in pairs(changed) do
		if code ~= CODES.ignored then
			local url = Url(path).parent
			while url and url ~= empty do
				local s = tostring(url)
				new[s] = (new[s] or CODES.unknown) > code and new[s] or code
				url = url.parent
			end
		end
	end
	return new
end

---@param excluded string[]
---@param cwd Url
---@param repo Url
---@return Changes
local function propagate_down(excluded, cwd, repo)
	local new, rel = {}, cwd:strip_prefix(repo)
	for _, path in ipairs(excluded) do
		if rel:starts_with(path) then
			-- If `cwd` is a subdirectory of an excluded directory, also mark it as `excluded`
			new[tostring(cwd)] = CODES.excluded
		elseif cwd == repo:join(path).parent then
			-- If `path` is a direct subdirectory of `cwd`, mark it as `ignored`
			new[path] = CODES.ignored
		else
			-- Skipping, we only care about `cwd` itself and its direct subdirectories for maximum performance
		end
	end
	return new
end

---@param cwd string
---@param repo string
---@param changed Changes
local add = ya.sync(function(st, cwd, repo, changed)
	---@cast st State

	st.dirs[cwd] = repo
	st.repos[repo] = st.repos[repo] or {}
	for path, code in pairs(changed) do
		if code == CODES.unknown then
			st.repos[repo][path] = nil
		elseif code == CODES.excluded then
			-- Mark the directory with a special value `excluded` so that it can be distinguished during UI rendering
			st.dirs[path] = CODES.excluded
		else
			st.repos[repo][path] = code
		end
	end
	-- TODO: remove this
	if ui.render then
		ui.render()
	else
		ya.render()
	end
end)

---@param cwd string
local remove = ya.sync(function(st, cwd)
	---@cast st State

	local repo = st.dirs[cwd]
	if not repo then
		return
	end

	-- TODO: remove this
	if ui.render then
		ui.render()
	else
		ya.render()
	end
	st.dirs[cwd] = nil
	if not st.repos[repo] then
		return
	end

	for _, r in pairs(st.dirs) do
		if r == repo then
			return
		end
	end
	st.repos[repo] = nil
end)

---@param st State
---@param opts Options
local function setup(st, opts)
	st.dirs = {}
	st.repos = {}

	opts = opts or {}
	opts.order = opts.order or 1500

	local t = th.git or {}
	local styles = {
		[CODES.ignored] = t.ignored and ui.Style(t.ignored) or ui.Style():fg("darkgray"),
		[CODES.untracked] = t.untracked and ui.Style(t.untracked) or ui.Style():fg("magenta"),
		[CODES.modified] = t.modified and ui.Style(t.modified) or ui.Style():fg("yellow"),
		[CODES.added] = t.added and ui.Style(t.added) or ui.Style():fg("green"),
		[CODES.deleted] = t.deleted and ui.Style(t.deleted) or ui.Style():fg("red"),
		[CODES.updated] = t.updated and ui.Style(t.updated) or ui.Style():fg("yellow"),
	}
	local signs = {
		[CODES.ignored] = t.ignored_sign or "",
		[CODES.untracked] = t.untracked_sign or "?",
		[CODES.modified] = t.modified_sign or "",
		[CODES.added] = t.added_sign or "",
		[CODES.deleted] = t.deleted_sign or "",
		[CODES.updated] = t.updated_sign or "",
	}

	Linemode:children_add(function(self)
		local url = self._file.url
		local repo = st.dirs[tostring(url.base)]
		local code
		if repo then
			code = repo == CODES.excluded and CODES.ignored or st.repos[repo][tostring(url):sub(#repo + 2)]
		end

		if not code or signs[code] == "" then
			return ""
		elseif self._file.is_hovered then
			return ui.Line { " ", signs[code] }
		else
			return ui.Line { " ", ui.Span(signs[code]):style(styles[code]) }
		end
	end, opts.order)
end

---@type UnstableFetcher
local function fetch(_, job)
	local cwd = job.files[1].url.base
	local repo = root(cwd)
	if not repo then
		remove(tostring(cwd))
		return true
	end

	local paths = {}
	for _, file in ipairs(job.files) do
		paths[#paths + 1] = tostring(file.url)
	end

	-- stylua: ignore
	local output, err = Command("git")
		:cwd(tostring(cwd))
		:arg({ "--no-optional-locks", "-c", "core.quotePath=", "status", "--porcelain", "-unormal", "--no-renames", "--ignored=matching" })
		:arg(paths)
		:stdout(Command.PIPED)
		:output()
	if not output then
		return true, Err("Cannot spawn `git` command, error: %s", err)
	end

	local changed, excluded = {}, {}
	for line in output.stdout:gmatch("[^\r\n]+") do
		local code, path = match(line)
		if code == CODES.excluded then
			excluded[#excluded + 1] = path
		else
			changed[path] = code
		end
	end

	if job.files[1].cha.is_dir then
		ya.dict_merge(changed, bubble_up(changed))
	end
	ya.dict_merge(changed, propagate_down(excluded, cwd, Url(repo)))

	-- Reset the status of any files that don't appear in the output of `git status` to `unknown`,
	-- so that cleaning up outdated statuses from `st.repos`
	for _, path in ipairs(paths) do
		local s = path:sub(#repo + 2)
		changed[s] = changed[s] or CODES.unknown
	end

	add(tostring(cwd), repo, changed)

	return false
end

return { setup = setup, fetch = fetch }
