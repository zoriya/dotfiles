local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local pip3 = require "nvim-lsp-installer.core.managers.pip3"
local name = "robotframework-lsp"

configs[name] = {
	default_config = {
		filetypes = { "robot" },
		root_dir = lspconfig.util.root_pattern ".git",
	},
}

vim.cmd[[au BufRead,BufNewFile *.robot setfiletype robot]]

local root_dir = server.get_server_root_path(name)

local my_server = server.Server:new {
	name = name,
	root_dir = root_dir,
	installer = pip3.packages { "robotframework-lsp" },
	languages = { "robot" },
	homepage = "https://github.com/robocorp/robotframework-lsp",
	async = true,
	default_options = {
		cmd = { path.concat { pip3.venv_path(root_dir), "robotframework_ls" } },
	},
}

servers.register(my_server)
