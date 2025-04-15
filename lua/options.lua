vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.ts = 2
vim.opt.sw = 2

vim.opt.hlsearch = true

vim.opt.undofile = true
vim.opt.undodir = "/Users/oyagci/.vimundo/"

vim.cmd[[colorscheme tokyonight]]
vim.g.ctrlp_extensions = {'buffertag', 'tag', 'line', 'dir'}

vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}
