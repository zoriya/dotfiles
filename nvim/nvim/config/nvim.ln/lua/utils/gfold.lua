local ok, gfold = pcall(require, "gfold")
if not ok then
	return
end

gfold.setup({
	picker = {
		on_select = function(repo)
			if not repo then
				return
			end
			vim.cmd("cd " .. repo.path)
			vim.cmd("%bw!")
			vim.lsp.stop_client(vim.lsp.get_active_clients())
			vim.cmd("e .")
		end
	},
	status = {
		enable = false,
	},
	cwd = vim.fn.getenv("HOME") .. "/projects",
})

local wk = require "which-key"
wk.register({
	r = { "<cmd>lua require 'gfold'.pick_repo()<CR>", "Switch Repo" },
}, {
	prefix = "<leader>"
})
