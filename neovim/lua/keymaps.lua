local map = vim.keymap.set
local gitsigns = require("gitsigns")

-- find
map("n", "<leader>ff", Snacks.picker.files, { desc = "Files" })
map("n", "<leader>fg", Snacks.picker.grep, { desc = "Grep" })
map("n", "<leader>fb", Snacks.picker.buffers, { desc = "Buffers" })
map("n", "<leader>fr", Snacks.picker.recent, { desc = "Recent files" })
map("n", "<leader>fh", Snacks.picker.help, { desc = "Help" })
map("n", "<leader>fk", Snacks.picker.keymaps, { desc = "Keymaps" })
map("n", "<leader>ft", function() Snacks.picker.pick("todo_comments") end, { desc = "Todos" })
map("n", "<leader>fd", Snacks.picker.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fs", Snacks.picker.lsp_symbols, { desc = "Symbols" })
map("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>fe", function() Snacks.explorer() end, { desc = "Explorer" })
map("n", "<leader>fm", function() require("conform").format({ lsp_format = "fallback" }) end, { desc = "Format" })
map("n", "gd", Snacks.picker.lsp_definitions, { desc = "Definition" })

-- motion / editing
map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap jump on current window" })
map("n", "S", "<Plug>(leap-from-window)", { desc = "Leap jump on other windows" })
map("n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Split/join block" })

for key, query in pairs({ af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner" }) do
	map({ "x", "o" }, key, function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end, { desc = query })
end

-- windows
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
map("n", "<leader>wH", "<cmd>vertical resize -5<cr>", { desc = "Narrow window" })
map("n", "<leader>wL", "<cmd>vertical resize +5<cr>", { desc = "Widen window" })
map("n", "<leader>wK", "<cmd>resize +3<cr>", { desc = "Taller window" })
map("n", "<leader>wJ", "<cmd>resize -3<cr>", { desc = "Shorter window" })

-- terminal
map({ "n", "t" }, "<C-/>", function() Snacks.terminal() end, { desc = "Terminal" })

-- git
map("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gg", Snacks.picker.git_status, { desc = "Git status" })
map("n", "<leader>gl", Snacks.picker.git_log, { desc = "Git log" })
map("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Open on GitHub" })
map("n", "<leader>gh", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gitsigns.nav_hunk("next")
	end
end, { desc = "Next hunk" })
map("n", "<leader>gH", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gitsigns.nav_hunk("prev")
	end
end, { desc = "Prev hunk" })
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gu", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })
