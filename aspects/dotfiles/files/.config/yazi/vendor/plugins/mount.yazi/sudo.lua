local M = {}

--- Verify if `sudo` is already authenticated
--- @return boolean
--- @return Error?
function M.sudo_already()
	local status, err = Command("sudo"):arg({ "--validate", "--non-interactive" }):status()
	return status and status.success or false, err
end

--- Authenticate `sudo` through Yazi's input component
--- @param program string
--- @return boolean authenticated
--- @return Error? err
function M.authenticate(program)
	if M.sudo_already() then
		return true
	end

	local value, event = ya.input {
		pos = { "top-center", y = 3, w = 40 },
		title = string.format("Password for `sudo %s`:", program),
		obscure = true,
	}
	if not value or event ~= 1 then
		return false, Err("Sudo password input cancelled")
	end

	local child, err = Command("sudo")
		:arg({ "--stdin", "--validate" })
		:stdin(Command.PIPED)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()
	if not child or err then
		return false, err
	end

	child:write_all(value .. "\n")
	child:flush()
	local output, err = child:wait_with_output()
	if not output or err then
		return false, err
	elseif not output.status.success then
		return false, Err("Incorrect sudo password")
	else
		return true
	end
end

--- Run a program with `sudo` privilege
--- @param program string
--- @param args table
--- @return Output? output
--- @return Error? err
function M.run_with_sudo(program, args)
	local authenticated, err = M.authenticate(program)
	if authenticated then
		return Command("sudo"):arg({ "--non-interactive", "--", program }):arg(args):output()
	else
		return nil, err
	end
end

return M
