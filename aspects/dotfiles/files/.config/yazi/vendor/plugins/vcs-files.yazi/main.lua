--- @since 26.5.6

local root = ya.sync(function() return cx.active.current.cwd end)

local function fail(content)
	return ya.notify { title = "VCS Files", content = tostring(content), timeout = 5, level = "error" }
end

---@param args string[]
---@return (fun(): string)?
---@return Error?
local function output(root, args)
	local output, err = Command("git"):cwd(tostring(root)):arg(args):output()
	if err then
		return nil, Err("Failed to run `git %s`, error: %s", table.concat(args, " "), err)
	elseif not output.status.success then
		return nil, Err("Failed to run `git %s`, stderr: %s", table.concat(args, " "), output.stderr)
	else
		return output.stdout:gmatch("[^\r\n]+")
	end
end

---@param a fun(): string
---@param b fun(): string
---@return fun(): string
local function merge(a, b)
	local seen = {}
	local function yield(s)
		if not seen[s] then
			seen[s] = true
			coroutine.yield(s)
		end
	end

	return ya.co(function()
		for line in a do
			yield(line)
		end
		for line in b do
			yield(line)
		end
	end)
end

local function entry()
	local root = root()

	local tracked, err = output(root, { "diff", "--name-only", "HEAD" })
	if err then
		return fail(err)
	end

	local untracked, err = output(root, { "ls-files", "--others", "--exclude-standard" })
	if err then
		return fail(err)
	end

	local id = ya.id("ft")
	local cwd = root:into_search("Git changes")
	ya.emit("cd", { Url(cwd), source = "search" })
	ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = {} }) })

	local files = {}
	for line in merge(tracked, untracked) do
		local url = cwd:join(line)
		local cha = fs.cha(url, true)
		if cha then
			files[#files + 1] = File { url = url, cha = cha }
		end
	end
	ya.emit("update_files", { op = fs.op("part", { id = id, url = Url(cwd), files = files }) })
	ya.emit("update_files", { op = fs.op("done", { id = id, url = cwd, cha = Cha { mode = tonumber("100644", 8) } }) })
end

return { entry = entry }
