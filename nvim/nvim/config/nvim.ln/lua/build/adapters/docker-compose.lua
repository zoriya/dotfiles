local Job = require 'plenary.job'

local M = {}

M.patterns = {
	"**/docker-compose.yml",
	"**/docker-compose.*.yml"
}

M.list = function(dc)
	return {
		{
			name = dc,
			file = dc,
			icon = "",
		},
	}
end

M.build = function(proj)
	local function add_to_qf(err, data)
		vim.fn.setqflist({}, "a", {
			lines = { err and err or data },
		})
	end

	return Job:new({
		command = "docker-compose",
		args = { "-f", proj.file, "build" },
		on_stdout = vim.schedule_wrap(add_to_qf),
		on_stderr = vim.schedule_wrap(add_to_qf),
	})
end


M.run = function(proj)
	return "docker-compose -f" .. proj.file .. " up --build"
end

M.require_build = false

return M
