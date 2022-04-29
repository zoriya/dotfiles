local Job = require 'plenary.job'

local M = {}

M.pattern = "*.sln"

M.list = function()
	local projs = io.popen("dotnet sln list | tail -n +3")
	local ret = {}
	for line in projs:lines() do
		table.insert(ret, {
			name = line:match("([^/]+).csproj$"),
			csproj = line,
			icon = "",
		})
	end
	projs:close()
	return ret
end

M.build = function(proj)
	local function add_to_qf(err, data)
		vim.fn.setqflist({}, "a", {
			efm = [[%f(%l\,%c): %t%*[^ ] %m]],
			lines = { err and err or data },
		})
	end

	return Job:new({
		command = "dotnet",
		args = { "build", proj.csproj },
		on_stdout = vim.schedule_wrap(add_to_qf),
		on_stderr = vim.schedule_wrap(add_to_qf),
	})
end


M.run = function(proj)
	return "dotnet run --project " .. proj.csproj
end

M.require_build = false

return M
