vim.opt.spell = true
vim.opt.spelllang = { "en", "programming" }

local ok, spellsitter = pcall(require, 'spellsitter')
if ok then
	spellsitter.setup()
end
