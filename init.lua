-- Bootstrap lazy.nvim
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

vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

-- Use a protected call to ensure that Lazy is set up correctly
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			---@type snacks.Config
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = { enabled = true },
				dashboard = { enabled = false },
				explorer = { enabled = true },
				indent = { enabled = true },
				input = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				scroll = { enabled = false },
				statuscolumn = { enabled = true },
				words = { enabled = true },
			},
		},

		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},

		{
			"nvim-lualine/lualine.nvim",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function ()
				require('lualine').setup {
					options = {
						icons_enabled = true,
						theme = 'auto',
						component_separators = { left = '', right = ''},
						section_separators = { left = '', right = ''},
						disabled_filetypes = {
							statusline = {},
							winbar = {},
						},
						ignore_focus = {},
						always_divide_middle = true,
						always_show_tabline = true,
						globalstatus = false,
						refresh = {
							statusline = 100,
							tabline = 100,
							winbar = 100,
						}
					},
					sections = {
						lualine_a = {'mode'},
						lualine_b = {'branch', 'diff', 'diagnostics'},
						lualine_c = {'filename'},
						lualine_x = {'encoding', 'fileformat', 'filetype'},
						lualine_y = {'progress'},
						lualine_z = {'location'}
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {'filename'},
						lualine_x = {'location'},
						lualine_y = {},
						lualine_z = {}
					},
					tabline = {},
					winbar = {},
					inactive_winbar = {},
					extensions = {}
				}
			end
		},

		{
			"romgrk/barbar.nvim",
			dependencies = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
			init = function() vim.g.barbar_auto_setup = false end,
			opts = {
				-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
				-- animation = true,
				-- insert_at_start = true,
				-- …etc.
			},
			version = "^1.0.0", -- optional: only update when a new 1.x version is released
		},

		{
			"neovim/nvim-lspconfig",
			config = function ()
				vim.lsp.enable("gopls")
			end,
		},

		"olimorris/codecompanion.nvim",

		{
			"nvim-treesitter/nvim-treesitter",
			ensure_installed = { "c", "vim", "lua", "go", "javascript" },
		},

		{
			-- Utilities for Go editing
			"ray-x/go.nvim",
			config = function ()
				require("go").setup()
			end,
		},

		"nvim-telescope/telescope.nvim",

		"preservim/tagbar",

		"fatih/vim-go",
	},
	checker = { enabled = true }
})


-- options

vim.cmd[[colorscheme tokyonight]]

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.ts = 2
vim.opt.sw = 2

vim.opt.hlsearch = true

vim.opt.undofile = true
vim.opt.undodir = "/Users/oyagci/.vimundo/"

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = true,
})

vim.g.ctrlp_extensions = {'buffertag', 'tag', 'line', 'dir'}

vim.keymap.set("n", "<C-n>", Snacks.explorer.open)

-- TagBar
vim.keymap.set("n", "<C-\\>", ":TagbarToggle<CR>")

-- Remove highlight
vim.keymap.set("n", "<C-c>", ":nohl<CR>")

vim.keymap.set("n", "<leader>jt", ":GoAddTag<CR>")

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)          -- Go to definition
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)          -- Find references
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- Show hover info
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Rename symbol
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions

-- Keybinding for :bn (Buffer Next)
vim.keymap.set("n", "<Tab>", ":bn<CR>", { noremap = true, silent = true })

-- Keybinding for :bp (Buffer Previous)
vim.keymap.set("n", "<S-Tab>", ":bp<CR>", { noremap = true, silent = true })

-- Disable annoying 'Entering Ex mode.  Type 'visual' to go to Normal mode.'
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })

-- Format document
-- vim.keymap.set("n", "<leader>f", function()
--     vim.lsp.buf.format({ async = true })
-- end, { noremap = true, silent = true })

-- Organize imports
vim.keymap.set("n", "<leader>o", function()
    vim.cmd("!isort %")
    vim.cmd("edit") -- Reload the buffer to reflect changes
end, { noremap = true, silent = true })

vim.g.go_doc_keywordprg_enabled = 0


-- keymaps

vim.keymap.set("n", "<leader>cc", function()
    require("coverage").load()
end, { noremap = true, silent = true, desc = "Load coverage" })

vim.keymap.set("n", "<leader>ct", function()
    require("coverage").toggle()
end, { noremap = true, silent = true, desc = "Toggle coverage view" })

vim.keymap.set("n", "<leader>cs", function()
    require("coverage").summary()
end, { noremap = true, silent = true, desc = "Show coverage summary" })


vim.keymap.set("n", "<leader>tt", function()
    require("neotest").run.run()
end, { noremap = true, silent = true, desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { noremap = true, silent = true, desc = "Run tests in file" })

vim.keymap.set("n", "<leader>ts", function()
    require("neotest").summary.toggle()
end, { noremap = true, silent = true, desc = "Toggle test summary" })

vim.keymap.set("n", "<leader>to", function()
    require("neotest").output.open({ enter = true })
end, { noremap = true, silent = true, desc = "Open test output" })

-- Keymap to jump to the next error
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Go to next error" })

-- Keymap to jump to the previous error
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { noremap = true, silent = true, desc = "Go to previous error" })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- autocmds

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
local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})
