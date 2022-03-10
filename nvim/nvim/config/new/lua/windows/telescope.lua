local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require "telescope.actions"

telescope.setup({
	defaults = {
		prompt_prefix = "   ",
		selection_caret = " ",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
			}
		},
		path_display = { "truncate" },
		mappings = {
			i = {
				["<A-k>"] = actions.move_selection_previous,
				["<A-j>"] = actions.move_selection_next,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,                    -- false will only do exact matching
			override_generic_sorter = true,  -- override the generic sorter
			override_file_sorter = true,     -- override the file sorter
		}
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "-E", ".git" },
		},
	},
})

telescope.load_extension('fzf')

local wk = require("which-key")
wk.register({
	f = { "<cmd>Telescope find_files<cr>", "Find files", },
	F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	g = {
		name = "Git",
		s = { "<cmd>Telescope git_status<cr>", "Git status" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
	},
}, {
	prefix = "<leader>",
})
