local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "maintained",
	sync_install = false,
	indent = {
		enable = true,
		disable = { },
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})
