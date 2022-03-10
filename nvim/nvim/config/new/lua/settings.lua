local options = {
	fileencoding = "utf-8",
	smartindent = true,
	expandtab = false,
	shiftwidth = 4,
	tabstop = 4,

	hlsearch = true,
	ignorecase = true,
	smartcase = true,

	mouse = "a",
	cursorline = true,
	sidescrolloff = 8,
	wrap = false,

	termguicolors = true,
	swapfile = false,
	undofile = true,
	updatetime = 300,                        -- faster completion (4000ms default)

	number = true,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "yes",

	list = true,
	listchars = {
		space = "·",
		tab = "▷ ",
		extends = "◣",
		precedes = "◢",
		nbsp = "○",
	},
	fillchars = {
		diff = "╱",
	},
	colorcolumn = "80,120",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move in insert mode --
keymap("i", "<C-j>", "<Down>", opts)
keymap("i", "<C-k>", "<Up>", opts)
keymap("i", "<C-h>", "<Left>", opts)
keymap("i", "<C-l>", "<Right>", opts)

keymap("i", "<C-BS>", "<C-w>", opts)

vim.cmd [[ augroup highlight_yank
	autocmd!
		autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
	augroup end
]]

