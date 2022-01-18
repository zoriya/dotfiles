vim.g.mergetool_layout = 'lmr'
-- possible values: 'local' (default), 'remote', 'base'
vim.g.mergetool_prefer_revision = 'base'

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "mh", "<cmd>MergetoolDiffExchangeLeft<cr>", opts)
keymap("n", "ml", "<cmd>MergetoolDiffExchangeRight<cr>", opts)
