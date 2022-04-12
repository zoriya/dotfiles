local ok, metals = pcall(require, "metals")
if not ok then
	return
end

-- NOTE: You may or may not want java included here. You will need it if you want basic Java support
-- but it may also conflict if you are using something like nvim-jdtls which also works on a java filetype
-- autocmd.
vim.cmd [[
	augroup lsp
		au!
		au FileType java,scala,sbt lua require("metals").initialize_or_attach(metals_config)
	augroup end
]]

metals_config = metals.bare_config()
metals_config.settings = {
	showImplicitArguments = true,
	showInferredType = true,
	showImplicitConversionsAndClasses = true,
}
-- metals_config.init_options.statusBarProvider = "on"

metals_config.on_attach = function(client, bufnr)
	metals.setup_dap()
	require "lsp.handlers".on_attach(client, bufnr)
end

local tok, telescope = pcall(require, "telescope")
if not tok then
	return
end
telescope.load_extension('metals')

