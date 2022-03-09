local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = false,
		update_in_insert = true,
	})
end

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		vim.cmd [[
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]]
	end
end

local wk = require("which-key")
wk.register({
	["[d"] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', "Prev diagnostic" },
	["]d"] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', "Next diagnostic" },
	gl = { "<cmd>lua vim.diagnostic.open_float()<CR>", "See diagnostics" },
	["<leader>l"] = {
		name = "LSP",
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
	},
})

local lsp_keymaps = function(bufnr)
	wk.register({
		g = {
			D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', "Go to declaration" },
			d = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Go to definition" },
			I = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Go to implementation" },
			r = { '<cmd>lua vim.lsp.buf.references()<CR>', "Go to reference(s)" },
		},
		K = { '<cmd>lua vim.lsp.buf.hover()<CR>', "See LSP tooltip" },
		["<C-k>"] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', "See signature help" },
		["<leader>l"] = {
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
	lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return M
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)


return M
