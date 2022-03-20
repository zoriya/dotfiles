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

M.list_projs = function ()
	local projs = {}

	for _, adapter in pairs(M.adapters) do
		for _, match in pairs(vim.fn.glob(adapter.pattern, false, true)) do
			for _, proj in pairs(adapter.list(match)) do
				proj.adapter = adapter
				proj.source = match
				table.insert(projs, proj)
			end
		end
	end
	return projs
end

M.select_proj = function (on_select)
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
		if not proj then return end
		M.projects[vim.fn.getcwd()] = proj
		if on_select then
			on_select()
		end
	end)
end

M.get_project = function ()
	return M.projects[vim.fn.getcwd()]
end

M.build = function ()
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.build)
		return
	end
	vim.cmd(M.config.runner .. " " .. proj.adapter.build(proj))
end


return M
