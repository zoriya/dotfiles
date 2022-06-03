vim.g.vimtex_complete_enabled = false
vim.g.vimtex_mappings_disable = {
	n = {
		"<localleader>li",
		"<localleader>lI",
		"<localleader>lt",
		"<localleader>lT",
		"<localleader>lq",
		"<localleader>lv",
		"<localleader>lr",
		"<localleader>ll",
		"<localleader>lL",
		"<localleader>lk",
		"<localleader>lK",
		"<localleader>le",
		"<localleader>lo",
		"<localleader>lg",
		"<localleader>lG",
		"<localleader>lc",
		"<localleader>lC",
		"<localleader>lm",
		"<localleader>lx",
		"<localleader>lX",
		"<localleader>ls",
		"<localleader>la",
	},
	x = {
		"<localleader>lL",
	},
}
vim.g.vimtex_syntax_enabled = false -- Treesiter for the win.
vim.g.vimtex_syntax_conceal_disable = true
vim.g.vimtex_quickfix_enabled = false
vim.g.vimtex_view_method = "zathura"

function LATEX_PREVIEW()
	local wk = require "which-key"
	wk.register({
		mp = { "<cmd>VimtexView<CR>", "Latex preview" },
	}, {
		prefix = "<leader>",
		buffer = 0,
	})
end

vim.cmd("au FileType tex lua LATEX_PREVIEW()")
