local Iterator = require "plenary.iterators"

local M = {}

M.pattern = "*.sln"

M.list = function ()
	local projs = io.popen("dotnet sln list | tail -n +3")
	local ret = Iterator.from_fun(projs:lines("a"))
		:map(function(x) return {x:match("%\a+.csproj$"), x} end)
		:tolistn()
	projs:close()
	return ret
end

M.build = function ()
	return "dotnet build"
end

M.errorformat = ""

M.run = function (proj)
	return "dotnet run --project " .. proj[2]
end

return M
