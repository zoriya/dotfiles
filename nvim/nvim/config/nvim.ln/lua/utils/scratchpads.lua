vim.g["codi#interpreters"] = {
	python = {
		bin = 'python3',
	},
}

vim.g["codi#virtual_text_pos"] = 90

local wk = require "which-key"
wk.register({
	s = { "<cmd>CodiSelect<cr>", "Open a Sratchpad" },
}, {
	prefix = "<leader>",
})
