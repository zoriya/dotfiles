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
			return icon .. " " .. proj.name, { {{0, 5}, "Comment"} }
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

M.post_build = function ()
	vim.g.errorformat = M._old_efm
	if M._post_callback then
		M._post_callback(vim.g.asyncrun_code)
	end
end

M.build = function (post)
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.build)
		return
	end
	proj.adapter.build(proj, {
		on_exit = post,
	}):start()
end

M.run = function ()
	local proj = M.get_project()
	if not proj then
		M.select_proj(M.run)
		return
	end
	M.build(function (status)
		print(status)
		if status == 0 then
			vim.cmd(":cclose")
			vim.cmd(":AsyncRun -mode=terminal -focus=0 -rows=" .. M.config.height .. " " .. proj.adapter.run(proj))
		else
			vim.notify("Build failed")
		end
	end)
end

M.cancel = function ()
	vim.cmd(":AsyncStop")
end

return M
