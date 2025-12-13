local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<leader>b", "<cmd>Bufferin<cr>", { desc = "Open Bufferin" })

vim.keymap.set("n", "[[", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Jump to previous diagnostic" })
vim.keymap.set("n", "]]", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Jump to previous diagnostic" })

vim.keymap.set("n", "<leader>dd", "<cmd>Lspsaga show_cursor_diagnostics<cr>", { desc = "Show diagnostic under cursor" })
vim.keymap.set("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<cr>", { desc = "Show buffer diagnostics" })
vim.keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<cr>", { desc = "Show line diagnostics" })

vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>")
vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>")
vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<cr>")
vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<cr>")
vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>")

vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })
