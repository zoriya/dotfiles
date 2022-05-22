-- vim.opt.spell = true
vim.opt.spelllang = { "en", "programming" }

local ok, spellsitter = pcall(require, 'spellsitter')
if ok then
	spellsitter.setup()
end


function MARKDOWN_PREVIEW()
	local wk = require "which-key"
	wk.register({
		mp = { "<cmd>MarkdownPreviewToggle<CR>", "Markdown preview" },
	}, {
		prefix = "<leader>",
		buffer = 0,
	})
end

vim.cmd("au FileType markdown lua MARKDOWN_PREVIEW()")
