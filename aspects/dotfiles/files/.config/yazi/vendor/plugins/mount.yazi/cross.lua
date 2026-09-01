local M = {}

--- @param type "mount"|"unmount"|"eject"
--- @param partition table
function M.operate(type, partition)
	if not partition then
		return
	elseif not partition.sub then
		return -- TODO: mount/unmount main disk
	end

	local cmd, output, err
	if ya.target_os() == "macos" then
		cmd, output, err = "diskutil", M.diskutil(type, partition.src)
	elseif ya.target_os() == "linux" then
		if type == "eject" and partition.src:match("^/dev/sr%d+") then
			M.udisksctl("unmount", partition.src)
			cmd, output, err = "eject", M.eject(partition.src)
		elseif type == "eject" then
			M.udisksctl("unmount", partition.src)
			cmd, output, err = "udisksctl", M.udisksctl("power-off", partition.src)
		else
			cmd, output, err = "udisksctl", M.udisksctl(type, partition.src)
		end
	end

	if not cmd then
		M.fail("mount.yazi is not currently supported on your platform")
	elseif not output then
		M.fail("Failed to spawn `%s`: %s", cmd, err)
	elseif not output.status.success then
		M.fail("Failed to %s `%s`: %s", type, partition.src, output.stderr)
	end
end

--- @param type "mount"|"unmount"|"eject"
--- @param src string
--- @return Output? output
--- @return Error? err
function M.diskutil(type, src) return Command("diskutil"):arg({ type, src }):output() end

--- @param type "mount"|"unmount"|"power-off"
--- @param src string
--- @return Output? output
--- @return Error? err
function M.udisksctl(type, src)
	local args = { type, "-b", src, "--no-user-interaction" }
	local output, err = Command("udisksctl"):arg(args):output()

	if not output or err then
		return nil, err
	elseif output.stderr:find("org.freedesktop.UDisks2.Error.NotAuthorizedCanObtain", 1, true) then
		local tx, rx = table.unpack(require(".main").permit)
		tx:send(true)
		ya.emit("which:dismiss", {})
		output, err = M.udisks_dbus(type, src)
		if not output then
			output, err = M.udisksctl_interactive(type, src)
		end
		rx:recv()
		return output, err
	else
		return output
	end
end

--- @param type "mount"|"unmount"|"power-off"
--- @param src string
--- @return Output? output
--- @return Error? err
function M.udisks_dbus(type, src)
	local obj, err = M.gdbus_resolve(
		"/org/freedesktop/UDisks2/Manager",
		"org.freedesktop.UDisks2.Manager.ResolveDevice",
		string.format("{'path': <%q>}", src),
		"{}"
	)
	if not obj then
		return nil, err
	end

	local method, options = "", "{}"
	if type == "mount" then
		local user = ya.user_name()
		if not user then
			return nil, Err("Cannot determine the current user")
		end
		method = "org.freedesktop.UDisks2.Filesystem.Mount"
		options = string.format("{'as-user': <%q>}", user)
	elseif type == "unmount" then
		method = "org.freedesktop.UDisks2.Filesystem.Unmount"
	elseif type == "power-off" then
		obj, err = M.gdbus_resolve(obj, "org.freedesktop.UDisks2.Block.GetDrive")
		if not obj then
			return nil, err
		end
		method = "org.freedesktop.UDisks2.Drive.PowerOff"
	else
		return nil, Err("Unsupported UDisks operation: %s", type)
	end

	return require(".sudo").run_with_sudo("gdbus", M.gdbus_args(obj, method, options))
end

--- @param type "mount"|"unmount"|"power-off"
--- @param src string
--- @return Output? output
--- @return Error? err
function M.udisksctl_interactive(type, src)
	local permit = ui.hide()
	local output, err = Command("udisksctl"):arg({ type, "-b", src }):stdin(Command.INHERIT):output()
	permit:drop()
	return output, err
end

--- @param src string
--- @return Output? output
--- @return Error? err
function M.eject(src) return Command("eject"):arg({ "--traytoggle", src }):output() end

function M.fail(...) ya.notify { title = "Mount", content = string.format(...), timeout = 10, level = "error" } end

--- @param obj string
--- @param method string
--- @param ... string
--- @return string? obj
--- @return Error? err
function M.gdbus_resolve(obj, method, ...)
	local output, err = Command("gdbus"):arg(M.gdbus_args(obj, method, ...)):output()
	if not output or err then
		return nil, err
	elseif not output.status.success then
		return nil, Err("%s", output.stderr)
	else
		local result = output.stdout:match("objectpath '([^']+)'")
		return result, result and nil or Err("Unexpected `gdbus` response: %s", output.stdout)
	end
end

--- @param obj string
--- @param method string
--- @param ... string
--- @return string[] args
function M.gdbus_args(obj, method, ...)
	return { "call", "--system", "--dest", "org.freedesktop.UDisks2", "--object-path", obj, "--method", method, ... }
end

return M
