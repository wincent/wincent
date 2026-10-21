local M = {}

function M:provide(job)
	local ops = require(".ops")
	if ops[job.op] then
		return ops[job.op](job)
	else
		return false, require(".rc").error("Unsupported", "Unsupported rclone operation: %s", job.op)
	end
end

return M
