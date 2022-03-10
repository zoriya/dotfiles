local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "rounded" }
		end,
	},
}

return packer.startup(function(use)
	use "wbthomason/packer.nvim"
	use 'lewis6991/impatient.nvim'

	use "tpope/vim-surround"
	use "tpope/vim-unimpaired"
	use "tpope/vim-speeddating"
	use "tpope/vim-repeat"

	use "folke/tokyonight.nvim"

	use {
		{ 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } },
		{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
		'stevearc/dressing.nvim',
	}
	use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }
	use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" }
	use "folke/which-key.nvim"
	use "akinsho/toggleterm.nvim"

	use {
		'neovim/nvim-lspconfig',
		'williamboman/nvim-lsp-installer',
	}
	use {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
	}

	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "numToStr/Comment.nvim"
	use "JoosepAlviste/nvim-ts-context-commentstring"

	use { "lukas-reineke/virt-column.nvim", config = function() require("virt-column").setup() end }
	use "lukas-reineke/indent-blankline.nvim"

	use { "lewis6991/gitsigns.nvim", requires = { 'nvim-lua/plenary.nvim' } }

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

