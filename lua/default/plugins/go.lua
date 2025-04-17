return {
	{
		"fatih/vim-go",
		config = function()
			vim.g.go_doc_keywordprg_enabled = 0
		end,
	},
	{
		-- Utilities for Go editing
		"ray-x/go.nvim",
		config = function()
			require("go").setup()
		end,
	},
}
