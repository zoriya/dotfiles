local has_icon, nwicon = pcall(require, 'nvim-web-devicons')

local M = {
	adapters = {},
	projects = {},
	config = {
		runner = "AsyncRun",
	},
}

table.insert(M.adapters, require "build.adapters.dotnet")

M.setup = function (config)
	M.config = vim.tbl_deep_extend('keep', M.config, config)
end

-- https://stackoverflow.com/questions/49907620/how-to-fuse-array-in-lua
local function concatArray(a, b)
	local result = {unpack(a)}
	table.move(b, 1, #b, #result + 1, result)
	return result
end

M.list_projs = function ()
	local projs = {}

	for _, adapter in pairs(M.adapters) do
		for _, match in pairs(vim.fn.glob(adapter.pattern, false, true)) do
			projs = concatArray(projs, adapter.list(match))
		end
	end
	return projs
end

M.select_proj = function ()
	local projs = M.list_projs()
	vim.ui.select(projs, {
		prompt = "Select a project",
		format_item = function (proj)
			local icon = proj.icon or has_icon and nwicon.get_icon(
				vim.fn.fnamemodify(proj.file, ':t'),
				vim.fn.fnamemodify(proj.file, ':e'),
				{ default = true }
			) or " "
			return icon .. " " .. proj.name
		end
	}, function (proj)
		M.projects[vim.fn.getcwd()] = proj
		if M.config.on_select then
			M.config.on_select()
		end
	end)
end

M.get_project = function ()
	return M.projects[vim.fn.getcwd()]
end

M.build = function ()
	vim.cmd(M.config.runner .. " " .. M.get_project().adapter.build())
end


return M
