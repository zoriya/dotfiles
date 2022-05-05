local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all",
	ignore_install = { "phpdoc" },
	sync_install = false,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = {},
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = false,

			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ia"] = "@parameter.inner",
				["aa"] = "@parameter.outer",
			},
		},
	},
	autotag = {
		enable = true,
	},
})
