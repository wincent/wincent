local M = {}

local rc = require(".rc")

local function quote(key, value)
	if type(value) == "boolean" or type(value) == "number" then
		value = tostring(value)
	end

	if type(value) == "string" then
		return "'" .. value:gsub("'", "''") .. "'"
	else
		return nil, rc.error("InvalidInput", "rclone backend option `%s` must be a scalar", key)
	end
end

local function relative(path) return (tostring(path):gsub("^/+", "")) end

local function filesystem(opts)
	local backend = opts.backend
	if type(backend) ~= "table" or type(backend.type) ~= "string" then
		return nil, rc.error("InvalidInput", "rclone VFS requires `backend.type`")
	end

	local s = ""
	for key, value in pairs(backend) do
		if key ~= "type" then
			local quoted, err = quote(key, value)
			if quoted then
				s = s .. "," .. key .. "=" .. quoted
			else
				return nil, err
			end
		end
	end

	return string.format(":%s%s:%s", backend.type, s, opts.root or "")
end

local function target(opts, url)
	local base, err = filesystem(opts)
	if not base then
		return nil, err
	end

	local rel = relative(url.path)
	if rel == "" or base:sub(-1) == ":" or base:sub(-1) == "/" then
		return base .. rel
	else
		return base .. "/" .. rel
	end
end

-- Split a copy URL into rclone's filesystem and path:
--   local /tmp/a becomes "/", "/tmp/a"
--   rclone /a under :local:/data becomes ":local:/data", "a"
local function endpoint(opts, url)
	url = url.physical
	if url.spec.is_regular then
		return "/", tostring(url.path)
	elseif url.spec.scheme ~= "rclone" then
		return nil, nil, rc.error("CrossesDevices", "rclone copy requires local or rclone endpoints")
	end

	local base, err = filesystem(opts)
	if base then
		return base, relative(url.path)
	else
		return nil, nil, err
	end
end

local function stat(item)
	return Stat {
		kind = item.Name:sub(1, 1) == "." and 2 or 0,
		mode = tonumber(item.IsDir and "40700" or "100644", 8),
		len = item.IsDir and 0 or math.max(item.Size or 0, 0),
		mtime = item.ModTime and ya.time(item.ModTime),
	}
end

local function item(opts, url)
	local base, err = filesystem(opts)
	if not base then
		return nil, err
	end

	local result, err = rc.call("operations/stat", opts, {
		fs = base,
		remote = relative(url.path),
		opt = { noMimeType = true },
		_config = { UseServerModTime = true },
	})
	if not result then
		return nil, err
	elseif result.item then
		return result.item
	else
		return nil, rc.error("NotFound", "No such rclone file: %s", url)
	end
end

function M.Capabilities()
	return {
		absolute = 1,
		canonicalize = 1,
		casefold = 1,
		copy_from = 1,
		copy_to = 1,
		create_dir = 1,
		create_file = 1,
		create_file_new = 1,
		file = 1,
		metadata = 1,
		open = 1,
		read_dir = 1,
		remove_dir = 1,
		remove_dir_all = 1,
		remove_file = 1,
		rename = 1,
		reroute = 1,
		revalidate = 1,
		symlink_metadata = 1,
	}
end

function M.Absolute(job) return job.url end

function M.Canonicalize(job) return job.url end

function M.Casefold(job) return job.url end

function M.Metadata(job)
	local item, err = item(job.opts, job.url)
	return item and stat(item), err
end

function M.SymlinkMetadata(job) return M.Metadata(job) end

function M.ReadDir(job)
	return ya.co(function()
		local base, err = filesystem(job.opts)
		if not base then
			return nil, err
		end

		local result, err = rc.call("operations/list", job.opts, {
			fs = base,
			remote = relative(job.url.path),
			opt = { noMimeType = true },
			_config = { UseServerModTime = true },
		})
		if not result then
			return nil, err
		end

		for _, item in ipairs(result.list) do
			local stat = stat(item)
			local url = job.url:join(item.Name)
			coroutine.yield(File { url = url, stat = stat, lstat = stat })
		end
	end)
end

function M.File(job)
	local stat, err = M.Metadata(job)
	return stat and File { url = job.url, stat = stat, lstat = stat }, err
end

function M.Revalidate(job)
	local new, err = M.File { opts = job.opts, url = job.file.url }
	if not new then
		return nil, err
	end

	local so, sn = job.file.stat, new.stat
	if so.mtime ~= sn.mtime or so.len ~= sn.len or so.mode ~= sn.mode then
		return new
	end
end

function M.Reroute(job)
	-- TODO: should we use `args.root`?
	return M.File { opts = job.opts, url = job.url:join("/") }
end

function M.Open(job)
	local d = job.demand
	if d.append then
		return nil, rc.error("Unsupported", "rclone does not support append")
	elseif d.read and d.write then
		return nil, rc.error("Unsupported", "rclone does not support read/write handles")
	elseif d.write and not (d.create_new or d.truncate) then
		return nil, rc.error("Unsupported", "rclone writes require truncate or create_new")
	elseif not d.read and not d.write then
		return nil, rc.error("InvalidInput", "rclone open requires read or write access")
	elseif d.read and (d.create or d.create_new or d.truncate) then
		return nil, rc.error("InvalidInput", "rclone creation and truncation require write access")
	end

	if d.read or (d.truncate and not (d.create or d.create_new)) then
		local stat, err = M.Metadata(job)
		if not stat then
			return nil, err
		elseif stat.is_dir then
			return nil, rc.error("IsADirectory", "rclone path is a directory: %s", job.url)
		end
	end

	if d.read then
		return { id = ya.id("ft") }
	elseif d.create_new then
		local ok, err = M.CreateFileNew(job)
		if not ok then
			return nil, err
		end
	elseif d.truncate then
		local ok, err = M.CreateFile(job)
		if not ok then
			return nil, err
		end
	end
	return { id = ya.id("ft"), seekless = true }
end

function M.CreateFile(job)
	local tx, stream = ya.chan("mpsc", 1)
	tx:send(nil)
	job.stream = stream

	local _, err = M.Write(job)()
	return err == nil, err
end

function M.CreateFileNew(job)
	local stat, err = M.Metadata(job)
	if stat and stat.is_dir then
		return false, rc.error("IsADirectory", "rclone path is a directory: %s", job.url)
	elseif stat then
		return false, rc.error("AlreadyExists", "rclone file already exists: %s", job.url)
	elseif err.kind ~= "NotFound" then
		return false, err
	end

	local dest, err = target(job.opts, job.url)
	if not dest then
		return false, err
	end

	local result, err = rc.call("core/command", job.opts, { command = "touch", arg = { dest }, opt = {} })
	if not result then
		return false, err
	elseif result.error then
		return false, rc.error("Other", "%s", result.result or "rclone touch failed")
	end
	return true
end

function M.CreateDir(job)
	local base, err = filesystem(job.opts)
	if not base then
		return false, err
	end

	local result, err = rc.call("operations/mkdir", job.opts, { fs = base, remote = relative(job.url.path) })
	return result ~= nil, err
end

function M.RemoveDir(job)
	local base, err = filesystem(job.opts)
	if not base then
		return false, err
	end

	local result, err = rc.call("operations/rmdir", job.opts, { fs = base, remote = relative(job.url.path) })
	return result ~= nil, err
end

function M.RemoveDirAll(job)
	if relative(job.url.path) == "" then
		return false, rc.error("InvalidInput", "Cannot purge the rclone VFS root")
	end

	local dest, err = target(job.opts, job.url)
	if not dest then
		return false, err
	end

	local result, err = rc.call("operations/purge", job.opts, { fs = dest, remote = "" })
	if result then
		return true
	elseif err.kind == "NotFound" then
		return true
	elseif tostring(err) == "rmdir failed: 404 Not Found" then
		return true
	else
		return false, err
	end
end

function M.RemoveFile(job)
	local base, err = filesystem(job.opts)
	if not base then
		return false, err
	end

	local result, err = rc.call("operations/deletefile", job.opts, { fs = base, remote = relative(job.url.path) })
	return result ~= nil, err
end

function M.Rename(job)
	local base, err = filesystem(job.opts)
	if not base then
		return false, err
	end

	local result, err = rc.call("operations/movefile", job.opts, {
		srcFs = base,
		srcRemote = relative(job.from.path),
		dstFs = base,
		dstRemote = relative(job.to),
	})
	return result ~= nil, err
end

function M.Read(job)
	return ya.co(function()
		local item, err = item(job.opts, job.url)
		if not item then
			return nil, err
		elseif item.Size >= 0 and job.offset >= item.Size then
			return -- Some backends ignore a range starting at EOF and return the entire file.
		end

		local src, err = target(job.opts, job.url)
		if not src then
			return nil, err
		end

		local req, err = rc.open("core/command", job.opts, {
			command = "cat",
			arg = { src },
			opt = { offset = tostring(job.offset) },
			returnType = "STREAM_ONLY_STDOUT",
		})
		if not req then
			return nil, err
		end

		local resp, err = rc.bytes(req:start())
		if not resp then
			return nil, err
		end

		local tail = ""
		while true do
			local chunk, err = resp:chunk()
			if not chunk then
				if err then
					return nil, err
				elseif tail ~= "{}\n" then
					return nil, rc.error("InvalidData", "Incomplete rclone command output")
				end
				return
			end

			tail = tail .. chunk
			if #tail > 3 then
				local bytes = tail:sub(1, -4)
				if #bytes > 0 then
					coroutine.yield(bytes)
				end
				tail = tail:sub(-3)
			end
		end
	end)
end

function M.Write(job)
	return ya.co(function()
		local parent, name = job.url.parent, job.url.name
		if not parent or not name then
			return nil, rc.error("IsADirectory", "Cannot create a file at the rclone VFS root")
		end

		local base, remote, err = endpoint(job.opts, parent)
		if not base then
			return nil, err
		end

		local req, err = rc.open("operations/uploadfile", job.opts, { fs = base, remote = remote })
		if not req then
			return nil, err
		end

		local tx, part = ya.http.part("file", { filename = name, content_type = "application/octet-stream" })
		local session = req:part(part):start()
		while true do
			local chunk, ok = job.stream:recv()
			if not chunk or not ok then
				break
			end
			local ok, err = tx:write(chunk.bytes)
			if not ok then
				return nil, err
			end
			coroutine.yield(chunk.to)
		end

		local ok, err = tx:flush()
		if not ok then
			return nil, err
		end

		ya.drop(tx)
		local result, err = rc.json(session)
		if not result then
			return nil, err
		end
	end)
end

function M.Close() return true end

function M.CopyTo(job)
	return ya.co(function()
		local from_opts, to_opts
		if job.op == "CopyTo" then
			from_opts = job.opts
			to_opts = job.to.spec.scheme == "rclone" and job.peer.opts or {}
		else
			from_opts = job.from.spec.scheme == "rclone" and job.peer.opts or {}
			to_opts = job.opts
		end

		local src_base, src_remote, err1 = endpoint(from_opts, job.from)
		local dst_base, dst_remote, err2 = endpoint(to_opts, job.to)
		if not src_base then
			return nil, err1
		elseif not dst_base then
			return nil, err2
		end

		local config = ya.dict_merge(ya.dict_merge({}, from_opts.config or {}), to_opts.config or {})
		local opts = { config = next(config) and config or nil }
		local group = "yazi/" .. ya.hash(string.format("%s\0%s\0%.9f", job.from, job.to, ya.time().unix))
		local req, err = rc.open("operations/copyfile", opts, {
			srcFs = src_base,
			srcRemote = src_remote,
			dstFs = dst_base,
			dstRemote = dst_remote,
			_group = group,
		})
		if not req then
			return nil, err
		end

		local session <close> = req:start()
		local sent = 0
		while not session:finished() do
			local stats, err = rc.call("core/stats", opts, { group = group, short = true })
			if not stats then
				return nil, err
			end

			local bytes = stats.bytes or 0
			if bytes > sent then
				coroutine.yield(bytes - sent)
				sent = bytes
			end

			ya.sleep(1)
		end

		local result, err1 = rc.json(session)
		local stats, err2 = rc.call("core/stats", opts, { group = group, short = true })
		rc.call("core/stats-delete", opts, { group = group })
		if not result then
			return nil, err1
		elseif not stats then
			return nil, err2
		end

		local bytes = stats.bytes or 0
		if bytes > sent then
			coroutine.yield(bytes - sent)
		end
		coroutine.yield(0)
	end)
end

function M.CopyFrom(job) return M.CopyTo(job) end

return M
