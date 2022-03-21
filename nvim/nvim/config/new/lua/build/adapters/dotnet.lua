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

M.build = function ()
	return "dotnet build"
end

M.errorformat = [[%f(%l\\,%c):\ %t%*[^\ ]\ %m]]

M.run = function (proj)
	return "dotnet run --project " .. proj.csproj
end

return M
