vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

local filetype_settings = {
	typescript = { shiftwidth = 2, tabstop = 2 },
	javascript = { shiftwidth = 2, tabstop = 2 },
	markdown = { shiftwidth = 2, tabstop = 2 },
	python = { shiftwidth = 4, tabstop = 4 },
	lua = { shiftwidth = 2, tabstop = 2 },
	go = { shiftwidth = 4, tabstop = 4 },
	c = { shiftwidth = 4, tabstop = 4 },
}

local group = vim.api.nvim_create_augroup("FiletypeSettings", { clear = true })

for ft, settings in pairs(filetype_settings) do
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = ft,
		callback = function()
			vim.bo.shiftwidth = settings.shiftwidth
			vim.bo.tabstop = settings.tabstop
		end,
	})
end
