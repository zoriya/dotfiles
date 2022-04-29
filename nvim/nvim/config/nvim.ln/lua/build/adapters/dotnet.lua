local Job = require 'plenary.job'
local a = require("plenary.async_lib")
local async, await = a.async, a.await

local M = {}

M.pattern = "*.sln"

M.list = async(function()
	local ignore = 3
	local ret = {}

	Job:new({
		args = { "sln", "list" },
		on_stdout = function(_, proj)
			if ignore > 0 then
				ignore = ignore - 1
				return
			end
			table.insert(ret, {
				name = proj:match("([^/]+).csproj$"),
				csproj = proj,
				icon = "",
			})
		end,
	}):sync()
	return ret
end)

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
