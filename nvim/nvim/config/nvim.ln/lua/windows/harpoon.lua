local ok, harpoon = pcall(require, "harpoon")
if not ok then
	return
end

harpoon.setup({
	mark_branch = true,
	menu = {
		width = 100,
	},
})

local wk = require "which-key"
wk.register({
	["<C-H>"] = { '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', "Navigate to harpoon 1" },
	["<C-T>"] = { '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', "Navigate to harpoon 2" },
	["<C-N>"] = { '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', "Navigate to harpoon 3" },
	["<C-S>"] = { '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', "Navigate to harpoon 4" },
})
wk.register({
	a = { '<cmd>lua require("harpoon.mark").add_file()<CR>', "Mark file" },
	h = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', "Harpoon menu" },
}, {
	prefix = "<leader>"
})
