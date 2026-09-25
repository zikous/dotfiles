local autocmd = vim.api.nvim_create_autocmd

-- number/relativenumber are window-local; explorer/tree windows (e.g.
-- snacks) turn them off, so re-assert on every real file buffer
autocmd({ "BufWinEnter", "BufEnter" }, {
	callback = function()
		if vim.bo.buftype == "" then
			vim.wo.number = true
			vim.wo.relativenumber = true
		end
	end,
})

-- autoread.nvim is per-buffer and off by default: enable it on every file
autocmd("BufReadPost", {
	callback = function() vim.cmd("silent! AutoreadOn") end,
})

autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank() end,
})

-- restore cursor position
autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})
