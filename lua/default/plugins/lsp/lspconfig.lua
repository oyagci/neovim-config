return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.config("ts_ls", {
			filetypes = {
				"javascript",
				"typescript",
				"react",
				"typescriptreact",
			},
		})
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("yaml")
		vim.lsp.enable("gopls")
		vim.lsp.config("golangci-lint-langserver", {
			cmd = { "golangci-lint-langserver" },
			filetypes = { "go", "gomod" },
			init_options = {
				command = { "golangci-lint", "run", "--output.json.path=stdout", "--show-stats=false" },
			},
			root_markers = {
				".golangci.yml",
				".golangci.yaml",
				".golangci.toml",
				".golangci.json",
				"go.work",
				"go.mod",
				".git",
			},
			before_init = function(_, config)
				-- Add support for golangci-lint V1 (in V2 `--out-format=json` was replaced by
				-- `--output.json.path=stdout`).
				local v1
				-- PERF: `golangci-lint version` is very slow (about 0.1 sec) so let's find
				-- version using `go version -m $(which golangci-lint) | grep '^\smod'`.
				if vim.fn.executable("go") == 1 then
					local exe = vim.fn.exepath("golangci-lint")
					local version = vim.system({ "go", "version", "-m", exe }):wait()
					v1 = string.match(version.stdout, "\tmod\tgithub.com/golangci/golangci%-lint\t")
				else
					local version = vim.system({ "golangci-lint", "version" }):wait()
					v1 = string.match(version.stdout, "version v?1%.")
				end
				if v1 then
					config.init_options.command = { "golangci-lint", "run", "--out-format", "json" }
				end
			end,
		})
		vim.lsp.enable("golangci-lint-langserver")
		vim.lsp.config("lua_ls", {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							vim.fn.stdpath("config"),
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			---settings = {
			---	Lua = {},
			---},
		})
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("lua-language-server")
		vim.lsp.enable("clangd")

		vim.lsp.config("postgrestools", {
			cmd = { "postgrestools", "lsp-proxy" },
			filetypes = {
				"sql",
			},
			root_dir = vim.fs.root(0, { "postgrestools.jsonc" }),
			single_file_support = true,
		})
		vim.lsp.enable("postgrestools")

		vim.lsp.config("terraform-ls", {
			cmd = { "terraform-ls", "serve" },
			filetypes = { "terraform", "terraform-vars" },
			root_markers = { ".terraform", ".git" },
		})
		vim.lsp.enable("terraform-ls")

		vim.lsp.inlay_hint.enable(true)
	end,
}
