vim.g.tokyonight_style = "night"

vim.cmd [[
try
	colorscheme tokyonight
	hi VertSplit guifg=#3d59a1
catch /^Vim\%((\a\+)\)\=:E185/
	colorscheme default
	set background=dark
endtry
]]
