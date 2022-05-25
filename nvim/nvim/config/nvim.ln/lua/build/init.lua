local has_icon, nwicon = pcall(require, 'nvim-web-devicons')
local scan = require 'plenary.scandir'

local M = {
	adapters = {},
	projects = {},
	config = {
		height = 15,
	},
}

table.insert(M.adapters, require "build.adapters.dotnet")
table.insert(M.adapters, require "build.adapters.docker-compose")
table.insert(M.adapters, require "build.adapters.npm")

M.list_projs = function()
	local projs = {}

	-- TODO: Use async methods here. (currently waiting for plenary async jobs)

	for _, adapter in pairs(M.adapters) do
		for _, match in pairs(scan.scan_dir(".", { search_pattern = adapter.patterns, respect_gitignore = true })) do
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

M.select_proj = function(on_select)
	local projs = M.list_projs()
	vim.ui.select(projs, {
		prompt = "Select a project",
		format_item = function(proj)
			return proj.icon .. " " .. proj.name
		end
	}, function(proj)
		if not proj then return end
		M.projects[vim.fn.getcwd()] = proj
		if on_select then
			on_select()
		end
	end)
end

M.get_project = function()
	return M.projects[vim.fn.getcwd()]
end

M.build = function(post)
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
		:after(vim.schedule_wrap(post))
		:start()
end

M.run = function()
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.run)
		return
	end
	if proj.adapter.require_build then
		M.build(function(status)
			if status == 0 then
				M.run()
			else
				vim.notify("Build failed")
			end
		end)
		return
	end

	vim.cmd("cclose")
	local oldwin = vim.api.nvim_get_current_win()
	vim.cmd(M.config.height .. "split")
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win, buf)

	vim.cmd("term " .. proj.adapter.run(proj))
	vim.cmd("norm G")
	vim.cmd("setl nonumber norelativenumber")
	vim.api.nvim_set_current_win(oldwin)
end

return M
