vim.g["codi#interpreters"] = {
	python = {
		bin = 'python3',
	},
}

vim.g["codi#virtual_text_pos"] = 90

local wk = require "which-key"
wk.register({
	s = {
		name = "Scratchpads",
		n = { "<cmd>CodiSelect<cr>", "Open a Sratchpad" },
		e = { "<cmd>CodiExpand<cr>", "Expand the scratchad output" },
		t = { "<cmd>Codi!!<cr>", "Toggle the scratchpad output" },
	}
}, {
	prefix = "<leader>",
})
