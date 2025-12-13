return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		disable = { "glsl" },
		ensure_installed = { "go" },
	},
	"sheerun/vim-polyglot",
}
