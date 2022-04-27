
vim.g["dispatch_no_maps"] = 1


local wk = require("which-key")
wk.register({
	m = {
		name = "Build",
		b = { "<cmd>lua require('build').build()<cr>", "Build project" },
		r = { "<cmd>lua require('build').run()<cr>", "Run project" },
		s = { "<cmd>lua require('build').select_proj()<cr>", "Select project" },
		d = { "<cmd>lua require('build').debug()<cr>", "Debug project" },
	}
}, {
	prefix = "<leader>",
})

