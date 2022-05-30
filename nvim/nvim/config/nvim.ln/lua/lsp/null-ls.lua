local ok, nl = pcall(require, "null-ls")
if not ok then
	return
end
local u = require("null-ls.utils")

local sources = {
	nl.builtins.code_actions.eslint,
	nl.builtins.diagnostics.eslint,
	nl.builtins.formatting.eslint,
	nl.builtins.formatting.prettier,
}
nl.setup({
	debug = false,
	root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git", "node_modules"),
	sources = vim.tbl_map(function(source)
		return source.with({
			diagnostics_postprocess = function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity.HINT
			end,
		})
	end, sources),
})

local function sort_ca_results(lsp_results)
	local results = {}
	local null_results = {}

	for client_id, result in ipairs(lsp_results) do
		local client = vim.lsp.get_client_by_id(client_id)

		if client.name == "null-ls" then
			table.insert(null_results, result)
		else
			table.insert(results, result)
		end
	end

	-- Sort null-ls actions to the end
	return vim.list_extend(results, null_results)
end

local buf_request_all = vim.lsp.buf_request_all
local ca
ca = function(bufnr, method, params, callback)
	return buf_request_all(bufnr, method, params, function(lsp_results)
		vim.lsp.buf_request_all = buf_request_all
		local results = sort_ca_results(lsp_results)
		local res = callback(results)
		vim.lsp.buf_request_all = ca
		return res
	end)
end
vim.lsp.buf_request_all = ca
