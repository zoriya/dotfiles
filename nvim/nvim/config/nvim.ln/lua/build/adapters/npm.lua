local M = {}

M.patterns = { "**/package.json" }

M.list = function(package)
	return {
		{
			name = vim.fn.fnamemodify(package, ":h"), -- Use the name in the package.json
			folder = vim.fn.fnamemodify(package, ":h"),
			file = package,
		}
	}
end

M.build = function()
	return nil
end


M.run = function(proj)
	return "cd " .. proj.folder ..  " && npm start"
end

M.require_build = false

return M
