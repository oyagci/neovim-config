-- Force attach treesitter to golang files because it doesn't by itself for some reason...
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		local ts_highlight = require("vim.treesitter.highlighter")
		local parser = vim.treesitter.get_parser(0, "go")
		if parser ~= nil then
			ts_highlight.active[vim.api.nvim_get_current_buf()] = ts_highlight.new(parser)
		end
	end,
})
