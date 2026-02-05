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
		return require(".sudo").run_with_sudo("udisksctl", args)
	else
		return output
	end
end

--- @param src string
--- @return Output? output
--- @return Error? err
function M.eject(src) return Command("eject"):arg({ "--traytoggle", src }):output() end

function M.fail(...) ya.notify { title = "Mount", content = string.format(...), timeout = 10, level = "error" } end

return M
