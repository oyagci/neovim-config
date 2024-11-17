local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")

				lspconfig.gopls.setup({})
				lspconfig.pyright.setup({
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "normal",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						-- Format with black
						null_ls.builtins.formatting.black,
						-- Organize imports with isort
						null_ls.builtins.formatting.isort,
						-- Optional: Add diagnostics with flake8
						null_ls.builtins.diagnostics.flake8,
					},
				})
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local cmp = require("cmp")
				local lspconfig = require("lspconfig")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				lspconfig.gopls.setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
						},
					},
				})

				cmp.setup({
					mapping = {
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					},
					sources = {
						{ name = "nvim_lsp" },
						{ name = "buffer" },
					},
				})
			end,
		},
		{ "frazrepo/vim-rainbow" },
		{ "ray-x/guihua.lua" },
		{
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "python", "go" },
					highlight = { enable = true },
				})
			end,
		},
		{
			"ray-x/go.nvim",
			dependencies = {  -- optional packages
				"ray-x/guihua.lua",
				"neovim/nvim-lspconfig",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("go").setup()
			end,
			event = {"CmdlineEnter"},
			ft = {"go", 'gomod'},
			build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
		},
		{ "ctrlpvim/ctrlp.vim" },
		{ "preservim/nerdtree" },
		{ "hiphish/rainbow-delimiters.nvim" },
		{
			"junegunn/fzf",
			build = function()
				vim.fn["fzf#install"]()
			end,
		},
		{
			"junegunn/fzf.vim",
			dependencies = { "junegunn/fzf" },
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		{
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					bind = true,
					floating_window = true, -- Use a floating window to show signatures
					hint_enable = false, -- Disable inline hints
					floating_window_above_cur_line = true,
					handler_opts = {
						border = "rounded", -- Border style for the floating window
					},
				})
			end,
		},
		{ "preservim/tagbar" },
		{
			"kdheepak/tabline.nvim",
			dependencies = {
				  "hoob3rt/lualine.nvim",
					"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("tabline").setup({
					enable = true,
					options = {
						section_separators = {'', ''},
						component_separators = {'', ''},
						max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
						show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
						show_devicons = true, -- this shows devicons in buffer section
						show_bufnr = false, -- this appends [bufnr] to buffer section,
						show_filename_only = false, -- shows base filename only instead of relative path in filename
						modified_icon = "+ ", -- change the default modified icon
						modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
						show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
					},
				})
				vim.opt.sessionoptions:append({ "tabpages", "globals" })
			end
		},
		{
			"vim-airline/vim-airline",
			config = function()
				vim.g.airline_powerline_fonts = 1
				vim.g["airline#extensions#tabline#enabled"] = 1
				vim.g["airline#extensions#tagbar#enabled"] = 1
			end
		},
		{
			"vim-airline/vim-airline-themes",
			dependencies = {
				"vim-airline/vim-airline",
			},
			config = function()
				-- Unicode symbols
				vim.g.airline_left_sep = '»'
				vim.g.airline_left_sep = '▶'
				vim.g.airline_right_sep = '«'
				vim.g.airline_right_sep = '◀'
				vim.g.airline_symbols.linenr = '␊'
				vim.g.airline_symbols.linenr = '␤'
				vim.g.airline_symbols.linenr = '¶'
				vim.g.airline_symbols.branch = '⎇'
				vim.g.airline_symbols.paste = 'ρ'
				vim.g.airline_symbols.paste = 'Þ'
				vim.g.airline_symbols.paste = '∥'
				vim.g.airline_symbols.whitespace = 'Ξ'

				-- Airline symbols
				vim.g.airline_left_sep = ''
				vim.g.airline_left_alt_sep = ''
				vim.g.airline_right_sep = ''
				vim.g.airline_right_alt_sep = ''
				vim.g.airline_symbols.branch = ''
				vim.g.airline_symbols.readonly = ''
				vim.g.airline_symbols.linenr = ''
				vim.g.airline_theme = "violet"
			end
		},
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio",
			},
			config = function ()
				require("dapui").setup()
			end
		},
		{
			"mfussenegger/nvim-dap-python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function ()
				local dap = require("dap-python")
				dap.setup("/Users/oguzhan/.venv/bin/python")
			end
		},
		{
			"leoluz/nvim-dap-go",
			config = function ()
				require("dap-go").setup()
			end
		},
	},
})

require("options")
require("keymaps")
require("autocmds")

local dap = require("dap")
local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.keymap.set("n", "<F5>", function() dap.continue() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { noremap = true, silent = true })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { noremap = true, silent = true })
