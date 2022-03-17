local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local server_settings = {
	omnisharp = {
		handlers = {
			["textDocument/definition"] = require('omnisharp_extended').handler,
		},
		cmd_env = {
			["OMNISHARP_FormattingOptions:EnableEditorConfigSupport"] = true,
			["OMNISHARP_RoslynExtensionsOptions:enableAnalyzersSupport"] = true,
			["OMNISHARP_RoslynExtensionsOptions:enableImportCompletion"] = true,
			["OMNISHARP_RoslynExtensionsOptions:enableDecompilationSupport"] = true,
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require('schemastore').json.schemas(),
			},
		},
	},
	sumneko_lua = {
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
	},
}

lsp_installer.settings({
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗"
		}
	}
})

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}
	opts = vim.tbl_deep_extend("force", server:get_default_options(), opts)
	if server_settings[server.name] then
		opts = vim.tbl_deep_extend("force", server_settings[server.name], opts)
	end
	server:setup(opts)
end)

