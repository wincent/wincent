--- @since 25.5.31

local M = {}

function M:peek(job)
	local child, err = Command("lsar"):arg(tostring(job.file.url)):stdout(Command.PIPED):spawn()
	if not child then
		return ya.err("spawn `lsar` command failed: " .. err)
	end

	-- Skip the first line which is the archive file itself
	while true do
		local _, event = child:read_line()
		if event == 0 or event ~= 1 then
			break
		end
	end

	local limit = job.area.h
	local i, lines = 0, {}
	repeat
		local next, event = child:read_line()
		if event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines[#lines + 1] = next
		end
	until i >= job.skip + limit

	child:start_kill()
	if job.skip > 0 and i < job.skip + limit then
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		ya.preview_widget(job, ui.Text(lines):area(job.area))
	end
end

function M:seek(job) require("code"):seek(job) end

return M
