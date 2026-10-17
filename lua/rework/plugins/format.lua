return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local mark_ns = vim.api.nvim_create_namespace("conform_edited_ranges")

		local function text_diff(before, after)
			local opts = { result_type = "indices", algorithm = "histogram" }
			if vim.fn.has("nvim-0.12") == 1 then
				return vim.text.diff(before, after, opts)
			end
			---@diagnostic disable-next-line: deprecated
			return vim.diff(before, after, opts)
		end

		local function merge_line_ranges(ranges)
			table.sort(ranges, function(a, b)
				return a.first < b.first
			end)
			local merged = {}
			for _, range in ipairs(ranges) do
				local prev = merged[#merged]
				if prev and range.first <= prev.last + 1 then
					prev.last = math.max(prev.last, range.last)
				else
					merged[#merged + 1] = { first = range.first, last = range.last }
				end
			end
			return merged
		end

		-- Lines that differ from the file on disk.
		-- nil means format the whole buffer: the file is new, or every line changed.
		local function edited_line_ranges(bufnr)
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name == "" or vim.fn.filereadable(name) == 0 then
				return nil
			end

			local ok, disk_lines = pcall(vim.fn.readfile, name)
			if not ok then
				return nil
			end

			local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local hunks = text_diff(
				table.concat(disk_lines, "\n") .. "\n",
				table.concat(buf_lines, "\n") .. "\n"
			)
			local line_count = #buf_lines
			local ranges = {}
			for _, hunk in ipairs(hunks) do
				local start_line, count = hunk[3], hunk[4]
				local first, last
				if count == 0 then
					first = math.max(start_line, 1)
					last = math.min(start_line + 1, line_count)
				else
					first = start_line
					last = start_line + count - 1
				end
				if first >= 1 and last >= first and last <= line_count then
					ranges[#ranges + 1] = { first = first, last = last }
				end
			end

			ranges = merge_line_ranges(ranges)
			if #ranges == 1 and ranges[1].first == 1 and ranges[1].last == line_count then
				return nil
			end
			return ranges
		end

		local function format_opts(extra)
			return vim.tbl_extend("force", {
				lsp_fallback = true,
				async = false,
				timeout_ms = 5000,
			}, extra or {})
		end

		local function conform_range(bufnr, first, last)
			local line = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, true)[1] or ""
			return {
				start = { first, 0 },
				["end"] = { last, #line },
			}
		end

		local function format_edited(bufnr, ranges)
			local marks = {}
			for i, range in ipairs(ranges) do
				marks[i] = {
					first = vim.api.nvim_buf_set_extmark(bufnr, mark_ns, range.first - 1, 0, {}),
					last = vim.api.nvim_buf_set_extmark(bufnr, mark_ns, range.last - 1, 0, {}),
				}
			end

			local function mark_line(id)
				local pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, mark_ns, id, {})
				if not pos[1] then
					return nil
				end
				return pos[1] + 1
			end

			-- Format from the bottom. Extmarks follow a range when a format inserts lines above it.
			local ok, err = pcall(function()
				for i = #ranges, 1, -1 do
					local first = mark_line(marks[i].first)
					local last = mark_line(marks[i].last)
					if first and last then
						local line_count = vim.api.nvim_buf_line_count(bufnr)
						first = math.max(first, 1)
						last = math.min(math.max(last, first), line_count)
						conform.format(format_opts({
							bufnr = bufnr,
							undojoin = i ~= #ranges,
							range = conform_range(bufnr, first, last),
						}))
					end
				end
			end)
			vim.api.nvim_buf_clear_namespace(bufnr, mark_ns, 0, -1)
			if not ok then
				vim.notify("Format on save failed: " .. tostring(err), vim.log.levels.ERROR)
			end
		end

		conform.setup({
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "goimports", "gofmt", "gofumpt" },
				terraform = { "terraform_fmt" },
				glsl = {},
				sql = { "pg_format" },
			},
			format_on_save = function(bufnr)
				local ranges = edited_line_ranges(bufnr)
				if ranges == nil then
					return format_opts({ bufnr = bufnr })
				end
				if #ranges == 0 then
					return
				end
				format_edited(bufnr, ranges)
			end,
			formatters = {
				clang_format = {
					prepend_args = { "--style=file", "--fallback-style=LLVM" },
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
