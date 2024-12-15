local dap = require("dap")
local dapui = require("dapui")

dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	}
}

dap.configurations.go = {
	{
		type = "go",
		name = "Attach to Process",
		request = "attach",
		mode = "remote",
		processId = require('dap.utils').pick_process, -- Prompts to pick a running process
		cwd = "${workspaceFolder}",
	},
	{
		type = "go",
		name = "Debug Test",
		request = "launch",
		mode = "test",
		program = "${file}", -- Test the current file
		setupCommands = {
			{
				text = "break runtime.throw",
				description = "Break on panic",
			},
			{
				text = "break runtime.fatalpanic",
				description = "Break on fatal panic",
			},
		},
	},
	{
		type = "go",
		name = "Debug Specific Test",
		request = "launch",
		mode = "test",
		program = "${file}",
		args = { "-test.run", "TestFunctionName" }, -- Replace with a specific test
		setupCommands = {
			{
				text = "break runtime.throw",
				description = "Break on panic",
			},
			{
				text = "break runtime.fatalpanic",
				description = "Break on fatal panic",
			},
		},
	},
	{
		type = "go",
		name = "Launch with Lokal",
		request = "launch",
		mode = "exec", -- Mode for executing a specific program
		program = "/Users/oguzhan/bin/lokal", -- Path to the custom executable
		args = { "run" }, -- Arguments for the program
		cwd = "${workspaceFolder}", -- Current working directory
		console = "integratedTerminal", -- Redirects output to an integrated terminal
		setupCommands = {
			{
				text = "break runtime.throw",
				description = "Break on panic",
			},
			{
				text = "break runtime.fatalpanic",
				description = "Break on fatal panic",
			},
		},
	},
}

-- Automatically open the terminal when launching a debug session
dap.listeners.before.event_initialized["open_terminal"] = function()
    vim.cmd("split | terminal") -- Opens the terminal in a horizontal split
    vim.cmd("resize 10")        -- Resize the terminal split to 10 lines
end

-- Open DAP UI automatically
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
