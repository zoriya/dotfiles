local ok, dap = pcall(require, "dap")
if not ok then
	return
end

dap.adapters = {
	coreclr = {
		type = 'executable',
		command = 'netcoredbg',
		args = {'--interpreter=vscode'}
	},
}

dap.configurations = {
	cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			program = function()
				return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			end,
		},
	},
}


local wk = require("which-key")
wk.register({
	d = {
		name = "Debugger",
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		b = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')<cr>", "Conditional Breakpoint" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "REPL" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		n = { "<cmd>lua require'dap'.step_over()<cr>", "Next" },
		s = { "<cmd>lua require'dap'.step_into()<cr>", "Step" },
		o = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	},
}, {
	prefix = "<leader>"
})
