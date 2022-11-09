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
		au FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)
	augroup end
]]


local function metals_status_handler(_, status, ctx)
	-- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
	local val = {}
	if status.hide then
		val = {kind = "end"}
	elseif status.show then
		val = {kind = "begin", title = " "} -- status.text title is ignored else messages are duplicated
	elseif status.text then
		val = {kind = "report", message = status.text}
	else
		return
	end
	local info = {client_id = ctx.client_id}
	local msg = {token = "metals", value = val}
	-- call fidget progress handler
	vim.lsp.handlers["$/progress"](nil, msg, info)
end

metals_config = metals.bare_config()
metals_config.settings = {
	showImplicitArguments = true,
	showInferredType = true,
	showImplicitConversionsAndClasses = true,
}
metals_config.init_options.statusBarProvider = "on"
metals_config.handlers = {
	['metals/status'] = metals_status_handler,
}

metals_config.on_attach = function(client, bufnr)
	metals.setup_dap()
	require "lsp.handlers".on_attach(client, bufnr)
end

local tok, telescope = pcall(require, "telescope")
if not tok then
	return
end
telescope.load_extension('metals')

