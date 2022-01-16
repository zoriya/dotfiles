vim.g.mergetool_layout = 'lmr'
-- possible values: 'local' (default), 'remote', 'base'
vim.g.mergetool_prefer_revision = 'base'

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "eh", "<cmd>MergetoolDiffExchangeLeft<cr>", opts)
keymap("n", "el", "<cmd>MergetoolDiffExchangeRight<cr>", opts)
