local Job = require'plenary.job'

local M = {}

M.pattern = "*.sln"

M.list = function ()
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

M.build = function (proj, opts)
	return Job:new(vim.tbl_deep_extend("force", opts, {
		command = "dotnet",
		args = {"build", proj},
		on_stdout = function(error, data)
			print(error, data)
		end,
	}))
end

M.errorformat = [[%f(%l\,%c): %t%*[^ ] %m]]

M.run = function (proj)
	return "dotnet run --project " .. proj.csproj
end

return M
