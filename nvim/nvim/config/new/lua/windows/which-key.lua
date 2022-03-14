local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

vim.opt["timeoutlen"] = 500

wk.setup({
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

