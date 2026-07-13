local M = {}

local root = Path.os("/tmp/yazi-demo-vfs")

local function e(message)
	return Error.fs {
		kind = "Other",
		message = message,
	}
end

local function path(value) return root:join(tostring(value):gsub("^/+", "")) end

local function command(name, args)
	local status, err = Command(name):arg(args):status()
	if status and status.success then
		return true
	end
	return false, err or e(("`%s` failed"):format(name))
end

local function set_attrs(path, attrs)
	local ok1, ok2, err1, err2 = true, true, nil, nil
	if attrs.mode then
		ok1, err1 = command("chmod", { string.format("%o", attrs.mode % 4096), tostring(path) })
	end
	if attrs.mtime then
		ok2, err2 = command("touch", { "-m", "-t", os.date("%Y%m%d%H%M.%S", math.floor(attrs.mtime)), tostring(path) })
	end
	return ok1 and ok2, err1 or err2
end

function M:SetAttrs(job) return set_attrs(path(job.url.path), job.attrs) end

function M:Capabilities() return { symlink = true, hard_link = true, trash = true, copy_progressive = true } end

function M:ReadDir(job)
	local entries, read_err = fs.read_dir(Url(path(job.url.path)), { resolve = true })
	if not entries then
		return nil, read_err
	end

	for i, entry in ipairs(entries) do
		entries[i] = { url = job.url:join(Path.os(entry.name)), cha = entry.cha }
	end
	return entries
end

function M:SymlinkMetadata(job) return fs.cha(Url(path(job.url.path)), false) end

function M:Metadata(job) return fs.cha(Url(path(job.url.path)), true) end

function M:Canonicalize(job) return job.url end

function M:Absolute(job) return job.url end

function M:Casefold(job) return job.url end

function M:Open(job)
	local demand = job.demand
	local p = path(job.url.path)

	local _, open_err = fs.access()
		:append(demand.append)
		:create(demand.create)
		:create_new(demand.create_new)
		:read(demand.read)
		:truncate(demand.truncate)
		:write(demand.write)
		:open(Url(p))
	if open_err then
		return nil, open_err
	end

	if demand.create or demand.create_new then
		local ok, attrs_err = set_attrs(p, job.attrs)
		if not ok then
			return false, attrs_err
		end
	end

	if not demand.append then
		return 0
	end

	local cha, cha_err = fs.cha(Url(p), true)
	return cha and cha.len, cha_err
end

function M:CreateDir(job) return fs.create("dir", Url(path(job.url.path))) end

function M:HardLink(job) return command("ln", { tostring(path(job.from.path)), tostring(path(job.to)) }) end

function M:ReadLink(job)
	local output, err = Command("readlink"):arg(tostring(path(job.url.path))):output()
	if output and output.status.success then
		return Path.os(output.stdout:sub(1, -2))
	end
	return nil, err or e("`readlink` failed")
end

function M:Symlink(job) return command("ln", { "-s", job.original, tostring(path(job.url.path)) }) end

function M:Trash(job) return command("trash", { tostring(path(job.url.path)) }) end

function M:RemoveDir(job) return fs.remove("dir", Url(path(job.url.path))) end

function M:RemoveFile(job) return fs.remove("file", Url(path(job.url.path))) end

function M:Rename(job)
	local from, to = path(job.from.path), path(job.to)
	return fs.rename(Url(from), Url(to))
end

function M:Read(job)
	local file, open_err = io.open(tostring(path(job.url.path)), "rb")
	if not file then
		return nil, e(open_err or "cannot open for read")
	end

	local _, seek_err = file:seek("set", job.offset)
	if seek_err then
		file:close()
		return nil, e(seek_err)
	end

	local bytes, read_err = file:read(job.len)
	file:close()
	return bytes or "", read_err and e(read_err)
end

function M:Write(job)
	local p = path(job.url.path)

	local file, open_err = io.open(tostring(p), "r+b")
	if not file then
		return false, e(open_err or "cannot open for write")
	end

	local _, seek_err = file:seek("set", job.offset)
	if seek_err then
		file:close()
		return false, e(seek_err)
	end

	local wrote, write_err = file:write(job.bytes)
	file:close()
	return wrote ~= nil, write_err and e(write_err)
end

function M:Copy(job)
	local from, to = path(job.from.path), path(job.to)
	local size, copy_err = fs.copy(Url(from), Url(to))
	if not size then
		return nil, copy_err
	end

	local ok, attrs_err = set_attrs(to, job.attrs)
	return ok and size, attrs_err
end

function M:CopyProgressive(job)
	local from, to = path(job.from.path), path(job.to)
	local source, source_err = io.open(tostring(from), "rb")
	if not source then
		return false, e(source_err or "cannot open source for read")
	end

	local dest, dest_err = io.open(tostring(to), "wb")
	if not dest then
		source:close()
		return false, e(dest_err or "cannot open destination for write")
	end

	while true do
		local chunk, read_err = source:read(1024 * 1024)
		if not chunk then
			if read_err then
				source:close()
				dest:close()
				return false, e(read_err)
			end
			break
		end

		local wrote, write_err = dest:write(chunk)
		if not wrote then
			source:close()
			dest:close()
			return false, e(write_err or "cannot write destination")
		end

		local sent, send_err = job.tx:send(#chunk)
		if not sent then
			source:close()
			dest:close()
			return false, send_err
		end
	end

	source:close()
	dest:close()
	return set_attrs(to, job.attrs)
end

function M:SetLen(job) return command("truncate", { "-s", tostring(job.size), tostring(path(job.url.path)) }) end

function M:provide(job)
	local ok, err = fs.create("dir_all", Url(root))
	if not ok then
		return false, err
	end
	return self[job.op](self, job)
end

return M
