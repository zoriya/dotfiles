local Iterator = require "plenary.iterators"

local M = {
	adapters = {},
}

table.insert(M.adapters, require "build.adapters.dotnet")

M.list_projs = function ()
end

M.select_proj = function ()
	local projs = M.list_projs()
	vim.ui.select(projs, {
		prompt = "Select a project",
	}, function (proj)
		
	end)
end


return M
