vim.g.tokyonight_style = "night"

vim.cmd [[
try
	colorscheme tokyonight
	hi VertSplit guifg=#7aa2f7
catch /^Vim\%((\a\+)\)\=:E185/
	colorscheme default
	set background=dark
endtry
]]
