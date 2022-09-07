local ok, neotest = pcall(require, "neotest")
if not ok then
	return
end


neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
		require("neotest-vim-test")({
			ignore_file_types = { "python" },
		}),
	},
	icons = {
		failed = "",
		passed = "",
		running = "",
		skipped = "ﰸ",
		unknown = ""
	},
	strategies = {
		integrated = {
			height = 180,
			width = 180,
		}
	},
})

vim.g["test#csharp#runner"] = 'dotnettest'

--[[ vim.cmd [[ ]]
--[[ 	augroup test_output ]]
--[[ 		autocmd! ]]
--[[ 		autocmd FileType UltestSummary setl nolist ]]
--[[ 	augroup end ]]
--[[ ] ] ]]

local wk = require("which-key")
wk.register({
	u = {
		name = "Unit Tests",
		r = { 'lua require("neotest").run.run()', "Run nearest" },
		d = { 'lua require("neotest").run.run({strategy = "dap"})', "Debug nearest" },
		o = { 'lua require("neotest").output.open({ enter = true })', "Show test output" },
		a = { 'lua require("neotest").run.attach()', "Attach to the nearest running test" },
		s = { 'lua require("neotest").run.stop()', "Stop the nearest test" },
		t = { 'lua require("neotest").summary.toggle()', "Toggle the test window" },
	},
}, {
	prefix = "<leader>",
})

wk.register({
	["[u"] = { 'lua require("neotest").jump.prev({ status = "failed" })', "Prev failing test" },
	["]u"] = { 'lua require("neotest").jump.next({ status = "failed" })', "Next failing test" },
})
