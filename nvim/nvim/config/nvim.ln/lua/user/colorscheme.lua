vim.g.tokyonight_style = "night"

vim.cmd [[
try
  colorscheme tokyonight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

vim.cmd [[
  hi ColorColumn guibg=NONE ctermbg=NONE
]]
