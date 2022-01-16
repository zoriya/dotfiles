local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

lualine.setup({
	options = {
		theme = "auto", --bubbles_theme,
		component_separators = '|',
		section_separators = { left = '', right = '' },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "Trouble", "DiffviewFiles", "DiffviewFileHistory" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = {
			{
				'mode',
				separator = { left = '' },
				right_padding = 2,
				fmt = function(str) return string.format("%-7s", str) end
			},
		},
		lualine_b = { 'filename', 'branch' },
		lualine_c = {},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " " },
				always_visible = false,
			},
			'fileformat',
		},
		lualine_y = { 'filetype', 'progress' },
		lualine_z = {
			{ 'location', separator = { right = '' }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { 'filename' },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { 'location' },
	},
	tabline = {},
	extensions = {},
})

