local ok, dap = pcall(require, "dap")
if not ok then
	return
end

dap.defaults.fallback.focus_terminal = true
dap.defaults.fallback.terminal_win_cmd = ":lua require('dap.ui.widgets').new_centered_float_win(vim.api.nvim_create_buf(false, true))"

dap.adapters = {
	coreclr = {
		type = 'executable',
		command = '/usr/bin/netcoredbg',
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
				return "/home/anonymus-raccoon/projects/Kyoo/src/Kyoo.Host.Console/bin/Debug/net6.0/Kyoo.Host.Console.dll"
				-- return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			end,
			console = "externalTerminal",
		},
	},
}

dap.set_log_level('TRACE')

vim.fn.sign_define('DapBreakpoint', {text='', texthl='GlyphPalette9', linehl='', numhl=''})
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "GlyphPalette4", linehl = "", numhl = "" })
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='GlyphPalette9', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='GlyphPalette2', linehl='debugPC', numhl=''})


require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	highlight_changed_variables = true,
	highlight_new_as_changed = true,
	show_stop_reason = true,
})

local wk = require("which-key")
wk.register({
	d = {
		name = "Debugger",
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		b = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional Breakpoint" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "REPL" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		n = { "<cmd>lua require'dap'.step_over()<cr>", "Next" },
		s = { "<cmd>lua require'dap'.step_into()<cr>", "Step" },
		o = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	},
}, {
	prefix = "<leader>"
})
