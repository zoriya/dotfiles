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
	d = { "<cmd>Neogen any<cr>", "Generate documentation" },
}, {
	prefix = "<leader>",
})
