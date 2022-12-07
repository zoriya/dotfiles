local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

vim.opt["timeoutlen"] = 500

wk.setup({
	plugins = {
		spelling = {
			enabled = true,
		},
	},
	window = {
		border = "rounded",
	},
	operators = {
		gc = "Comments",
		ys = "Add Surroundings",
		yS = "Add Surroundings",
	}
})

wk.register({
	gc = {
		name = "Comment",
	},
	ys = { name = "Add Surroundings" },
	ds = { name = "Delete Surroundings" },
	cs = { name = "Change Surroundings" },
	yS = { name = "Add Surroundings" },
	dS = { name = "Delete Surroundings" },
	cS = { name = "Change Surroundings" },
}, {
	noremap = false,
})

wk.register({
	y = { "Yank to system clipboard" },
	Y = { "Yank line to system clipboard" },
	p = { "Past from system clipboard" },
	P = { "Past line from system clipboard" },
}, {
	prefix = "<leader>"
})

wk.register({
	["<leader>w"] = { "<cmd>ASToggle<cr>", "Toggle autosave" },
})
