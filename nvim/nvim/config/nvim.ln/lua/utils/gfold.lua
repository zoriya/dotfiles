local ok, gfold = pcall(require, "gfold")
if not ok then
	return
end

gfold.setup({
	picker = {
		on_select = function (repo)
			print(repo)
			if not repo then
				return
			end
			vim.cmd("cd " .. repo.path .. "|%bw|e .")
			print('toto')
		end
	}
})
