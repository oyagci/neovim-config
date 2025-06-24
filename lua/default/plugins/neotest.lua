return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		{
			"fredrikaverpil/neotest-golang",
			version = "*",
			dependencies = {
				"andythigpen/nvim-coverage", -- Added dependency
			},
		},
	},
	config = function()
		local neotest_golang_opts = { -- Specify configuration
			runner = "go",
			go_test_args = {
				"-v",
				"-race",
				"-count=1",
				"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
			},
		}
		require("neotest").setup({
			adapters = {
				require("neotest-golang")(neotest_golang_opts), -- Registration
			},
		})
	end,
}
