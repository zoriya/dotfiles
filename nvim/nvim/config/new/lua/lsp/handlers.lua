local M = {}

local on_attach = function(client, bufnr)
	local wk = require("which-key")
	wk.register({
		g = {
			D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', "Go to declaration" },
			d = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Go to definition" },
			I = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Go to implementation" },
			r = { '<cmd>lua vim.lsp.buf.references()<CR>', "Go to reference(s)" },
		},
		K = { '<cmd>lua vim.lsp.buf.hover()<CR>', "See LSP tooltip" },
		"<C-k>" = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', "See signature help" },
		"<leader>l" = {
			name = "LSP",
			r = { '<cmd>lua vim.lsp.buf.rename()<CR>', "Rename" },
			a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action" },
			f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', "Format" },
		}
	}, {
		buffer = bufnr,
	})
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
end

return M
