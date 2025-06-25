return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"eslint-lsp",
				"eslint_d",
				"gopls",
				"js-debug-adapter",
				"prettier",
				"stylua",
				"swiftlint",
				"terraform",
				"terraform-ls",
				"tflint",
				"typescript-language-server",
				"xmlformatter",
				"yaml-language-server",
				"yamlfix",
				"yamlfmt",
				"yamllint",
			},
		})
	end,
}
