vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
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

-- Run gofmt + goimports on save
--local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
--vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*.go",
--	callback = function()
--		require("go.format").goimports()
--	end,
--	group = format_sync_grp,
--})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
	desc = "TS_add_missing_imports",
	pattern = { "*.ts", "*.tsx" },
	callback = function()
		vim.lsp.buf.code_action({
			apply = true,
			---@diagnostic disable-next-line: missing-fields
			context = {
				only = {
					---@diagnostic disable-next-line: assign-type-mismatch
					"source.addMissingImports.ts",
					---@diagnostic disable-next-line: assign-type-mismatch
					"source.organizeImports.ts",
					---@diagnostic disable-next-line: assign-type-mismatch
					"source.removeUnusedImports.ts",
				},
			},
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "typescript", "typescriptreact", "ts", "tsx", "terraform" },
	callback = function()
		vim.treesitter.start()
	end,
})
