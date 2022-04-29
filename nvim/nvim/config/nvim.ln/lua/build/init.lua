local Job = require'plenary.job'
local has_icon, nwicon = pcall(require, 'nvim-web-devicons')

local M = {
	adapters = {},
	projects = {},
	config = {
		height = 15,
	},
}

table.insert(M.adapters, require "build.adapters.dotnet")

M.list_projs = function ()
	local projs = {}

	for _, adapter in pairs(M.adapters) do
		for _, match in pairs(vim.fn.glob(adapter.pattern, false, true)) do
			for _, proj in pairs(adapter.list(match)) do
				proj.adapter = adapter
				proj.source = match
				proj.icon = proj.icon or has_icon and nwicon.get_icon(
					vim.fn.fnamemodify(proj.file, ':t'),
					vim.fn.fnamemodify(proj.file, ':e'),
					{ default = true }
				) or " "
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
			return proj.icon .. " " .. proj.name
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

M.build = function (post)
	local proj = M.get_project()
	if not proj then
		M.select_proj(function() M.build(post) end)
		return
	end

	vim.fn.setqflist({}, "r", {
		title = proj.icon .. " " .. proj.name,
	})
	vim.api.nvim_command('copen')
	vim.api.nvim_command('wincmd p')

	proj.adapter.build(proj)
		:and_then(post)
		:start()
end

M.run = function ()
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.run)
		return
	end
	if proj.adapter.require_build then
		M.build(function (status)
			if status == 0 then
				M.run()
			else
				vim.notify("Build failed")
			end
		end)
		return
	end
	vim.api.nvim_command(":cclose")
	local buf = vim,api.nvim_create_buf(false, true)
	proj.adapter.run(proj):start()
	-- vim.cmd(":AsyncRun -mode=terminal -focus=0 -rows=" .. M.config.height .. " " .. proj.adapter.run(proj))
end

M.cancel = function ()
	vim.cmd(":AsyncStop")
end

return M
