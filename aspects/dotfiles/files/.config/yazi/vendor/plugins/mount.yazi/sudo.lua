local M = {}

--- Verify if `sudo` is already authenticated
--- @return boolean
--- @return Error?
function M.sudo_already()
	local status, err = Command("sudo"):arg({ "--validate", "--non-interactive" }):status()
	return status and status.success or false, err
end

--- Run a program with `sudo` privilege
--- @param program string
--- @param args table
--- @return Output? output
--- @return Error? err
function M.run_with_sudo(program, args)
	local cmd = Command("sudo")
		:arg({ "--stdin", "--user", "#" .. ya.uid(), "--", program })
		:arg(args)
		:stdin(Command.PIPED)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)

	if M.sudo_already() then
		return cmd:output()
	end

	local value, event = ya.input {
		pos = { "top-center", y = 3, w = 40 },
		title = string.format("Password for `sudo %s`:", program),
		obscure = true,
	}
	if not value or event ~= 1 then
		return nil, Err("Sudo password input cancelled")
	end

	local child, err = cmd:spawn()
	if not child or err then
		return nil, err
	end

	child:write_all(value .. "\n")
	child:flush()
	local output, err = child:wait_with_output()
	if not output or err then
		return nil, err
	elseif output.status.success or M.sudo_already() then
		return output
	else
		return nil, Err("Incorrect sudo password")
	end
end

return M
