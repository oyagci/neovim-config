return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			extend_gitsigns = true,
			lightbulb = {
				enable = true,
				sign = false,
				virtual_text = false,
			},
		})
	end,
}
