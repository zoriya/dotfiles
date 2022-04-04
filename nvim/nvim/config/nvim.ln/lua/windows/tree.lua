vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "",
		staged = "✓",
		unmerged = "",
		renamed = "➜",
		deleted = "",
		untracked = "U",
		ignored = "◌",
	},
	folder = {
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
	},
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup {
	hijack_netrw = true,
	update_cwd = true,
	view = {
		mappings = {
			list = {
				{ key = "<CR>", action = "edit_in_place" },
				{ key = "h", action = "close_node" },
				{ key = "<Left>", action = "close_node" },
			},
		},
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	update_focused_file = {
		enable = true,
		update_cwd = false,
		ignore_list = {},
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	git = {
		enable = true,
		ignore = true,
	},
	actions = {
		change_dir = {
			enable = false,
		},
		open_file = {
			quit_on_open = true,
		},
	},
}

local wk = require "which-key"
wk.register({
	["-"] = { "<cmd>lua require'nvim-tree'.open_replacing_current_buffer()<CR>", "Toggle explorer" }
})
