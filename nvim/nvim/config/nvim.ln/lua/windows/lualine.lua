local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local gps_on, gps = pcall(require, "nvim-navic")
if gps_on then
	gps.setup {
		highlight = true,
	}
end

local auto_save_state = false
local as_on, as = pcall(require, "auto-save")
if as_on then
	as.setup({
		write_all_buffers = true,
		print_enabled = false,
		callbacks = {
			enabling = function() auto_save_state = true end,
			disabling = function() auto_save_state = false end,
		}
	})
end

vim.opt["showmode"] = false

local toggleterm = {
	sections = {
		lualine_a = {
			{
				'mode',
				fmt = function(str) return string.format("%7s", str) end
			},
		},
		lualine_b = {
			function()
				return 'ToggleTerm #' .. vim.b.toggle_number
			end
		}
	},
	filetypes = { "toggleterm" },
}

lualine.setup({
	options = {
		theme = "auto",
		component_separators = '|',
		section_separators = { left = '', right = '' },
		always_divide_middle = true,
		globalstatus = true,
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = {
			{
				'mode',
				fmt = function(str) return string.format("%7s", str) end
			},
		},
		lualine_b = {
			{
				"diagnostics",
				sources = {
					function()
						local diag_severity = vim.diagnostic.severity

						local function workspace_diag(severity)
							local count = vim.diagnostic.get(nil, { severity = severity })
							return vim.tbl_count(count)
						end

						return {
							error = workspace_diag(diag_severity.ERROR),
							warn = workspace_diag(diag_severity.WARN),
							info = workspace_diag(diag_severity.INFO),
							hint = workspace_diag(diag_severity.HINT)
						}
					end,
				},
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " " },
				always_visible = false,
			}
		},
		lualine_c = {
			{
				function()
					return ""
				end,
				color = "ErrorMsg",
				cond = function() return not auto_save_state end,
			},
			{ 'filetype', colored = true, icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{
				'filename',
				separator = '>',
				path = 0,
				symbols = {
					modified = '',
					readonly = '[-]',
					unnamed = '[No Name]',
				},
			},
			{ gps.get_location, cond = gps_on and gps.is_available },
		},
		lualine_x = { require "dap".status, 'fileformat', },
		lualine_y = { 'branch', 'progress' },
		lualine_z = {
			{
				'location',
			},
		},
	},
	tabline = {},
	extensions = {
		"quickfix",
		"neo-tree",
		"fugitive",
		toggleterm
	},
})
