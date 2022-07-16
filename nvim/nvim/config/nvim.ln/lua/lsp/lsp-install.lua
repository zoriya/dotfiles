local ok, lspconfig = pcall(require, "lspconfig")
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok or not ok then
	return
end

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

lsp_installer.setup({
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		}
	}
})

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

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
		},
	},
})


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

lspconfig.ltex.setup({
	settings = {
		ltex = {
			dictionary = {
				en = { ":~/.cache/nvim/ltex.dictionary.en-us.txt" },
			},
		},
	},
})

for _, server in ipairs(lsp_installer.get_installed_servers()) do
	lspconfig[server.name].setup({})
end
