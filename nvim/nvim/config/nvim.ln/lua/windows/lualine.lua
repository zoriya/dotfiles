local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local gps_on, gps = pcall(require, "nvim-gps")
if gps_on then
	gps.setup({
		icons = {
			["container-name"] = '⛶ ',
		}
	})
end

vim.opt["showmode"] = false

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
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " " },
				always_visible = false,
			}
		},
		lualine_c = {
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
		lualine_x = { 'fileformat', },
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
		"nvim-tree",
		"fugitive",
	},
})
