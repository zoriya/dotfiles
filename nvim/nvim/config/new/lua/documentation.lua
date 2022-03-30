local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
	return
end

neogen.setup({
	snippet_engine = "luasnip",
	languages = {
		cs = {
			template = {
				annotation_convention = "xmldoc",
			}
		}
	}
})

local wk = require("which-key")
wk.register({
	n = {
		name = "Generate documentation",
		f = { "<cmd>Neogen func<CR>", "Function" },
		c = { "<cmd>Neogen class<CR>", "Class" },
		t = { "<cmd>Neogen type<CR>", "Type" },
	},
}, {
	prefix = "<leader>",
})
