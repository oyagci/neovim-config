vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

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

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10
