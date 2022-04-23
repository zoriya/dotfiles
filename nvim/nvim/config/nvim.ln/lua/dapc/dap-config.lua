local ok, dap = pcall(require, "dap")
if not ok then
	return
end

dap.defaults.csharp.exception_breakpoints = { "user-unhandled" }

dap.adapters = {
	coreclr = {
		type = 'executable',
		command = '/usr/bin/netcoredbg',
		args = { '--interpreter=vscode' }
	},
}

dap.configurations = {
	cs = {
		{
			type = "coreclr",
			name = "netcoredbg",
			request = "launch",
			program = function()
				return "/home/anonymus-raccoon/projects/Kyoo/src/Kyoo.Host.Console/bin/Debug/net6.0/Kyoo.Host.Console.dll"
				-- return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			end,
		},
	},
	scala = {
		{
			type = "scala",
			request = "launch",
			name = "Run",
			metals = {
				runType = "run",
			},
		}
	}
}

dap.set_log_level('TRACE')

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'GlyphPalette9', linehl = '', numhl = '' })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "GlyphPalette4", linehl = "", numhl = "" })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'GlyphPalette9', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'GlyphPalette2', linehl = 'debugPC', numhl = '' })

vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")


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
		s = { "<cmd>lua require'dap'.terminate()<cr>", "Stop session" },
		v = { "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes).open()<cr>", "Variables" },
		w = { "<cmd>Telescope dap frames<cr>", "Where (stack frames)" },
		e = { "<cmd>lua require'dap'.set_exception_breakpoints()<cr>", "Exception breakpoints" },
	},
}, {
	prefix = "<leader>"
})
wk.register({
	["<A-c>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
	["<A-n>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Next" },
	["<A-s>"] = { "<cmd>lua require'dap'.step_into({askForTargets=true})<cr>", "Step" },
	["<A-o>"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
	["<A-l>"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to line (cursor)" },
	["<A-k>"] = { "<Cmd>lua require('dap.ui.widgets').hover()<CR>", "DAP Hover" },
})

local pok, telescope = pcall(require, "telescope")
if pok then
	telescope.load_extension('dap')
end
