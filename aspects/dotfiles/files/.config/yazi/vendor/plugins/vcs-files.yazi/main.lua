--- @since 26.8.15
--- @sync entry

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

local function file(url)
	local file, err = fs.file(url.physical)
	return file and File { url = url, stat = file.stat, lstat = file.lstat, link_to = file.link_to }, err
end

local function read_dir(job)
	local root = job.url.physical

	local tracked, err = output(root, { "diff", "--name-only", "--relative", "HEAD" })
	if err then
		return nil, err
	end

	local untracked, err = output(root, { "ls-files", "--others", "--exclude-standard" })
	if err then
		return nil, err
	end

	for line in merge(tracked, untracked) do
		local url = job.url:join(line)
		local file = fs.file(url)
		if file then
			coroutine.yield(file)
		end
	end
end

local function entry()
	if not vf then
		return ya.async(function() require(".old"):entry() end) -- TODO: remove
	end

	vf.vcs = {
		default = { kind = "view", run = "vcs-files" },
	}

	ya.emit("cd", {
		Url {
			cx.active.current.cwd,
			scheme = "vcs",
			domain = "default",
			data = { "Git changes" },
		},
		raw = true,
	})
end

local function provide(_, job)
	local op = job.op
	if op == "Capabilities" then
		return { file = 1, read_dir = 1, revalidate = 1 }
	elseif op == "File" then
		return file(job.url)
	elseif op == "Revalidate" then
		return file(job.file.url)
	elseif op == "ReadDir" then
		return ya.co(function() return read_dir(job) end)
	else
		return false, Err("Unsupported VCS operation: %s", op)
	end
end

return { entry = entry, provide = provide }
