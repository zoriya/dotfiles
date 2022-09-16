local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = false,
		update_in_insert = true,
		float = {
			border = "rounded",
			source = "always",
		},
	})
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	local ok, inlay = pcall(require, "lsp-inlayhints")
	if ok then
		inlay.setup()
	end

	local shok, sh = pcall(require, "nvim-semantic-tokens")
	if shok then
		sh.setup {
			preset = "default",
			highlighters = { require 'nvim-semantic-tokens.table-highlighter' }
		}
	end
end

local function lsp_highlight_document(client)
	if client.server_capabilities.documentHighlightProvider then
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

function _LSP_FORMAT_FILTER(client)
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	for _, c in pairs(clients) do
		if c.name == "null-ls" and c.server_capabilities.documentFormattingProvider then
			return client.name == "null-ls"
		end
	end
	return true
end

local lsp_keymaps = function(bufnr)
	wk.register({
		g = {
			D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', "Go to declaration" },
			d = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Go to definition" },
			I = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Go to implementation" },
			r = { '<cmd>lua vim.lsp.buf.references()<CR>', "Go to reference(s)" },
			s = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Type definition" },
			S = "which_key_ignore",
		},
		K = { '<cmd>lua vim.lsp.buf.hover()<CR>', "See LSP tooltip" },
		["<C-k>"] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', "See signature help" },
		["<leader>l"] = {
			r = { '<cmd>lua vim.lsp.buf.rename()<CR>', "Rename" },
			a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action" },
			l = { '<cmd>lua vim.lsp.codelens.run()<CR>', "Run code lens" },
			f = { '<cmd>lua vim.lsp.buf.format({filter=_LSP_FORMAT_FILTER, async=true})<CR>', "Format" },
			g = { '<cmd>Telescope lsp_document_symbols<CR>', "Go to symbol" },
		}
	}, {
		buffer = bufnr,
	})
	wk.register({
		["<leader>f"] = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Range format" },
	}, {
		buffer = bufnr,
		mode = "v",
	})
end

local lsp_codelens = function()
	-- vim.cmd [[ autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh() ]]
end

local lsp_semhighlight = function(client)
	local caps = client.server_capabilities
	if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
		vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.buf.semantic_tokens_full()]]
	end
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
	lsp_codelens()
	lsp_semhighlight(client)

	require("lsp-inlayhints").on_attach(client, bufnr)
	require "nvim-navic".attach(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return M
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)


return M
