vim.g["test#csharp#runner"] = 'dotnettest'

vim.g["ultest_pass_sign"] = ""
vim.g["ultest_fail_sign"] = ""
vim.g["ultest_running_sign"] = ""
vim.g["ultest_not_run_sign"] = ""

vim.g["ultest_output_max_width"] = 180
vim.g["ultest_output_min_width"] = 180

vim.g["ultest_use_pty"] = 1

vim.cmd [[
	augroup test_output
		autocmd!
		autocmd FileType UltestSummary setl nolist
	augroup end
]]

local wk = require("which-key")
wk.register({
	u = {
		name = "Unit Tests",
		r = { "<Plug>(ultest-run-nearest)", "Run nearest" },
		o = { "<Plug>(ultest-output-show)", "Show test output" },
		j = { "<Plug>(ultest-output-jump)", "Jump to test output" },
		a = { "<Plug>(ultest-attach)", "Attach to the nearest running test" },
		s = { "<Plug>(ultest-stop-nearest)", "Stop the nearest test" },
		t = { "<cmd>UltestSummary!<cr>", "Toggle the test window" },
	},
}, {
	prefix = "<leader>",
})

wk.register({
	["[u"] = { "<Plug>(ultest-prev-fail)", "Prev failing test" },
	["]u"] = { "<Plug>(ultest-next-fail)", "Next failing test" },
})
