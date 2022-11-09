local ok, lspconfig = pcall(require, "lspconfig")
local status_ok, mason = pcall(require, "mason")
local lspok, mason_lsp = pcall(require, "mason-lspconfig")
local fmtok, mason_fmt = pcall(require, "mason-null-ls")
if not fmtok or not lspok or not status_ok or not ok then
	return
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

mason_lsp.setup({
	automatic_installation = true,
})

mason_fmt.setup({
	automatic_installation = true,
	ensure_installed = { "eslint_d", "prettierd" },
})


local util = require "lspconfig.util"
util.on_setup = util.add_hook_after(util.on_setup, function(config)
	local opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	if config.on_attach then
		config.on_attach = util.add_hook_after(config.on_attach, opts.on_attach)
	else
		config.on_attach = opts.on_attach
	end
	config.capabilities = opts.capabilities
end)

local servers = {}

lspconfig.omnisharp.setup({
	handlers = {
		["textDocument/definition"] = require('omnisharp_extended').handler,
	},
	cmd_env = {
		["OMNISHARP_FormattingOptions:EnableEditorConfigSupport"] = true,
		["OMNISHARP_RoslynExtensionsOptions:enableAnalyzersSupport"] = true,
		["OMNISHARP_RoslynExtensionsOptions:enableImportCompletion"] = true,
		["OMNISHARP_RoslynExtensionsOptions:enableDecompilationSupport"] = true,
		["OMNISHARP_msbuild:EnablePackageAutoRestore"] = true,
	},
})
table.insert(servers, "omnisharp")

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
})
table.insert(servers, "jsonls")


lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
table.insert(servers, "sumneko_lua")

lspconfig.robotframework_ls.setup({
	settings = {
		robot = {
			codeFormatter = "robotidy",
			variables = {
				RESOURCES = vim.fn.getcwd() .. "/tests/robot/",
			},
		},
	}
})
table.insert(servers, "robotframework_ls")

lspconfig.ltex.setup({
	settings = {
		ltex = {
			dictionary = {
				en = { ":~/.cache/nvim/ltex.dictionary.en-us.txt" },
			},
		},
	},
})
table.insert(servers, "ltex")

lspconfig.tsserver.setup({
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = 'all',
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			}
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = 'all',
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			}
		}
	}
})
table.insert(servers, "tsserver")

local function contains(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end

for _, server in ipairs(mason_lsp.get_installed_servers()) do
	if not contains(servers, server) then
		lspconfig[server].setup({})
	end
end
