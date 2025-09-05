vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })

local opts = {}

-- TagBar
vim.keymap.set("n", "<C-\\>", ":TagbarToggle<CR>")

-- Remove highlight
vim.keymap.set("n", "<C-c>", ":nohl<CR>")

vim.keymap.set("n", "<leader>jt", ":GoAddTag<CR>")
-- LSP
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Find references
vim.keymap.set("n", "K", vim.lsp.buf.hover, {}) -- Show hover info
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
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

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<leader>a", ":Lspsaga code_action<CR>", { desc = "Action" })
