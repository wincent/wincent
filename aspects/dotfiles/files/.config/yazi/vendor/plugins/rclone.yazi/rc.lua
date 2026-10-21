local M = {}

function M.error(kind, message, ...) return Error.fs { kind = kind, message = string.format(message, ...) } end

function M.socket() return rt.path.runtime_dir:join("rclone-" .. ya.id("app") .. ".sock") end

function M.http_error(status, bytes)
	local kind = "Other"
	if status == 400 then
		kind = "InvalidInput"
	elseif status == 401 or status == 403 then
		kind = "PermissionDenied"
	elseif status == 404 then
		kind = "NotFound"
	elseif status == 409 then
		kind = "AlreadyExists"
	elseif status == 507 then
		kind = "StorageFull"
	end

	local result = ya.json_decode(bytes)
	if type(result) == "table" and result.error then
		return M.error(kind, "%s", result.error)
	else
		return M.error(kind, "rclone RC returned HTTP %d: %s", status, bytes)
	end
end

function M.encode_args(args)
	local query, err = {}
	for key, value in pairs(args) do
		if type(value) == "table" then
			value, err = ya.json_encode(value)
			if not value then
				return nil, err
			end
		end
		query[#query + 1] = ya.percent_encode(key, { "query" }) .. "=" .. ya.percent_encode(tostring(value), { "query" })
	end
	return table.concat(query, "&")
end

function M.start()
	local child, err = Command("rclone"):arg({
		"rcd",
		"--rc-addr",
		"unix://" .. M.socket(),
		"--rc-no-auth",
		"--config",
		"",
	}):spawn()
	if not child then
		return false, err
	end

	for _ = 1, 50 do
		if ya.http("POST", "http://localhost/rc/noop"):socket(M.socket()):start():finish() then
			ya.hold(child)
			return true
		end

		local status, err = child:try_wait()
		if err then
			return false, err
		elseif status then
			return false, M.error("Other", "rclone rcd exited with status code %d", status.code)
		end
		ya.sleep(0.1)
	end

	child:start_kill()
	return false, M.error("TimedOut", "Timed out waiting for rclone rcd")
end

function M.ensure()
	if ya.http("POST", "http://localhost/rc/noop"):socket(M.socket()):start():finish() then
		return true
	end
	return M.start()
end

function M.open(endpoint, opts, args)
	if opts.config then
		args._config = args._config or {}
		for key, value in pairs(opts.config) do
			args._config[key] = value
		end
	end

	local query, err = M.encode_args(args)
	if not query then
		return nil, err
	end

	local ok, err = M.ensure()
	if not ok then
		return nil, err
	end

	return ya.http("POST", "http://localhost/" .. endpoint .. "?" .. query):socket(M.socket())
end

function M.bytes(session)
	local resp, err = session:finish()
	if not resp then
		return nil, err
	end

	local status = resp.status
	if status >= 200 and status < 300 then
		return resp
	end

	local bytes, err = resp:bytes()
	if bytes then
		return nil, M.http_error(status, bytes)
	else
		return nil, err
	end
end

function M.json(session)
	local resp, err = M.bytes(session)
	if not resp then
		return nil, err
	end

	local bytes, err = resp:bytes()
	if not bytes then
		return nil, err
	end

	local decoded = ya.json_decode(bytes)
	if decoded then
		return decoded
	else
		return nil, M.error("InvalidData", "Invalid JSON returned by rclone RC")
	end
end

function M.call(endpoint, opts, args)
	local req, err = M.open(endpoint, opts, args)
	if req then
		return M.json(req:start())
	else
		return nil, err
	end
end

return M
