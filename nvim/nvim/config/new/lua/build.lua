vim.g["dispatch_no_maps"] = 1

local wk = require("which-key")
wk.register({
	b = { "<cmd>Make<cr>", "Build project" },
}, {
	prefix = "<leader>",
})

