local ok, neotree = pcall(require, "neo-tree")
if not ok then
	return
end

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

neotree.setup {
	close_if_last_window = true,
	close_floats_on_escape_key = true,
	default_source = "filesystem",
	popup_border_style = "rounded",
	sort_case_insensitive = true,
	use_popups_for_input = false,
	use_default_mappings = true,
	default_component_configs = {
		git_status = {
			symbols = {
				-- Change type
				added     = "✚",
				deleted   = "",
				modified  = "",
				renamed   = "",
				-- Status type
				untracked = "",
				ignored   = "◌",
				unstaged  = "",
				staged    = "✓",
				conflict  = "",
			},
			align = "left",
		},
	},
	window = {
		position = "current",
		mappings = {
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["t"] = "open_tabnew",
			["w"] = "open_with_window_picker",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["R"] = "refresh",
			["a"] = { "add", config = { show_path = "none" } },
			["A"] = "add_directory", -- also accepts the config.show_path option.
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy", -- takes text input for destination
			["m"] = "move", -- takes text input for destination
			["q"] = "close_window",
			["?"] = "show_help",
			["h"] = function(state)
				local node = state.tree:get_node()
				if node.type == 'directory' and node:is_expanded() then
					require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
				else
					require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
				end
			end,
			["l"] = function(state)
				local node = state.tree:get_node()
				if node.type == 'directory' then
					if not node:is_expanded() then
						require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
					elseif node:has_children() then
						require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
					end
				end
			end,
			['<tab>'] = function(state)
				local node = state.tree:get_node()
				if require("neo-tree.utils").is_expandable(node) then
					state.commands["toggle_node"](state)
				else
					state.commands['open'](state)
					vim.cmd('Neotree reveal')
				end
			end,
		},
	},
	filesystem = {
		bind_to_cwd = false,
		filtered_items = {
			visible = false, -- when true, they will just be displayed differently than normal items
			hide_dotfiles = false,
			hide_gitignored = true,
		},
		follow_current_file = true,
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = false,
	},
	nesting_rules = {
		["js"] = { "js.map" },
	}
}

local wk = require "which-key"
wk.register({
	["-"] = { "<cmd>Neotree current dir=%:h reveal_force_cwd toggle<CR>", "Toggle explorer" },
	["<leader>e"] = { "<cmd>Neotree left toggle<CR>", "Toggle left explorer" },
})
