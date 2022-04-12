local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local lsn_status_ok, luasnip = pcall(require, "luasnip")
if not lsn_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = { "menuone", "preview", }
vim.opt.pumheight = 15

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "ﰠ",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	-- enabled = function()
	-- 	-- disable completion in comments
	-- 	local context = require 'cmp.config.context'
	-- 	-- keep command mode completion enabled when cursor is in a comment
	-- 	if vim.api.nvim_get_mode().mode == 'c' then
	-- 		return true
	-- 	else
	-- 		return not context.in_treesitter_capture("comment")
	-- 			and not context.in_syntax_group("Comment")
	-- 	end
	-- end,
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
			end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = 'luasnip' },
		-- { name = "buffer" },
		{ name = "path" },
	},
	formatting = {
		fields = { "abbr", "kind" },
		format = function(entry, vim_item)
			vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
			-- vim_item.menu = ({
			-- 	nvim_lsp = "[LSP]",
			-- 	luasnip = "[Snippet]",
			-- 	buffer = "[Buffer]",
			-- 	path = "[Path]",
			-- })[entry.source.name]
			return vim_item
		end,
	},
	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
	experimental = {
		ghost_text = true,
	},
})

cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})
