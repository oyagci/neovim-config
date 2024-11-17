-- NERDTree
vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>")

-- TagBar
vim.keymap.set("n", "<C-\\>", ":TagbarToggle<CR>")

-- Remove highlight
vim.keymap.set("n", "<C-c>", ":nohl<CR>")

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
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true })

-- Organize imports
vim.keymap.set("n", "<leader>o", function()
    vim.cmd("!isort %")
    vim.cmd("edit") -- Reload the buffer to reflect changes
end, { noremap = true, silent = true })
