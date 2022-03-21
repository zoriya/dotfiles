local has_icon, nwicon = pcall(require, 'nvim-web-devicons')

local M = {
	adapters = {},
	projects = {},
}

table.insert(M.adapters, require "build.adapters.dotnet")

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
	local old = vim.g.asyncrun_open
	vim.g.asyncrun_open = 10
	-- TODO: the gobal errorformat should not be overriden but it could not find how to excape the string.
	vim.cmd(":set errorformat=" .. proj.adapter.errorformat)
	vim.cmd(":AsyncRun " .. proj.adapter.build(proj))
	vim.g.asyncrun_open = old
end

M.run = function ()
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.run)
		return
	end
	-- TODO: build project before running it if required
	vim.cmd(":AsyncRun -mode=terminal " .. proj.adapter.run(proj))
end

return M
