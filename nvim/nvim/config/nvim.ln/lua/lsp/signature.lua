local ok, signature = pcall(require, "lsp_signature")
if not ok then
	return
end

signature.setup({
	doc_lines = 100,
	fix_pos = true,
	always_trigger = true,
	toggle_key = "<C-k>",
	floating_window = false,
})

