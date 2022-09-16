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
	use { "tpope/vim-unimpaired", config = function() vim.g.nremap = { ["[u"] = "", ["]u"] = "" } end }
	use "tpope/vim-speeddating"
	use "tpope/vim-repeat"
	use "tpope/vim-sleuth"
	use "nishigori/increment-activator"

	use { "airblade/vim-rooter", config = function() vim.g.rooter_manual_only = 1 end }
	use { "yyk/simply-auto-save.nvim", branch = "check-valid-buf",
		config = function() require "auto-save".setup({ write_all_buffers = true }) end }
	use { "AckslD/nvim-gfold.lua" }

	use { "lewis6991/spellsitter.nvim" }
	use { 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' }


	use "ggandor/lightspeed.nvim"
	use "ThePrimeagen/harpoon"


	use "folke/tokyonight.nvim"
	use { "catppuccin/nvim", as = "catppuccin" }

	use {
		{ 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } },
		{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
		'stevearc/dressing.nvim',
	}

	-- use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }
	use { "git@github.com:AnonymusRaccoon/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }
	use { 'kevinhwang91/nvim-bqf' }

	use "folke/which-key.nvim"
	use "akinsho/toggleterm.nvim"
	use "metakirby5/codi.vim"

	use {
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	}

	use "nvim-lualine/lualine.nvim"
	use { "RRethy/vim-hexokinase", run = "make hexokinase", config = function()
		vim.g["Hexokinase_optInPatterns"] = "full_hex,triple_hex,rgb,rgba,hsl,hsla"
	end }


	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	use "Hoffs/omnisharp-extended-lsp.nvim"
	use({ 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } })
	use "b0o/schemastore.nvim"
	use "jose-elias-alvarez/null-ls.nvim"
	use "lvimuser/lsp-inlayhints.nvim"
	use "theHamsta/nvim-semantic-tokens"

	use {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	}
	use "rafamadriz/friendly-snippets"

	use "ray-x/lsp_signature.nvim"
	use {
		"zbirenbaum/neodim",
		config = function()
			require("neodim").setup()
		end
	}
	use { "j-hui/fidget.nvim", config = function() require("fidget").setup {} end }


	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "windwp/nvim-autopairs"
	use "windwp/nvim-ts-autotag"
	use "numToStr/Comment.nvim"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use { "danymat/neogen", requires = "nvim-treesitter/nvim-treesitter", }
	use { "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig", }

	use "mfussenegger/nvim-dap"
	use { "theHamsta/nvim-dap-virtual-text", requires = { "nvim-treesitter/nvim-treesitter" } }
	use "AnonymusRaccoon/telescope-dap.nvim"
	-- use "nvim-telescope/telescope-dap.nvim"


	use {
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim"
		}
	}
	use { "nvim-neotest/neotest-python" }
	use { "nvim-neotest/neotest-vim-test", requires = { "vim-test/vim-test" } }


	use { "lukas-reineke/virt-column.nvim", config = function() require("virt-column").setup() end }
	use "lukas-reineke/indent-blankline.nvim"
	use "petertriho/nvim-scrollbar"

	use "tpope/vim-fugitive"
	use { "lewis6991/gitsigns.nvim", requires = { 'nvim-lua/plenary.nvim' } }

	use {
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	}
	use { "lervag/vimtex", ft = { "tex" } }

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
