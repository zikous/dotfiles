local o = vim.opt

vim.cmd.colorscheme "catppuccin-nvim"

o.showmode = false
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
-- gutter: fold arrow | line number | signs (git bar)
-- custom fold column: the builtin one prints fold-level digits on nested folds
function _G.fold_icon()
	local l = vim.v.lnum
	if vim.fn.foldclosed(l) == l then return "▸" end
	if vim.fn.foldlevel(l) > vim.fn.foldlevel(l - 1) then return "▾" end
	return " "
end
function _G.fold_click()
	local pos = vim.fn.getmousepos()
	vim.api.nvim_win_call(pos.winid, function()
		vim.api.nvim_win_set_cursor(0, { pos.line, 0 })
		vim.cmd("silent! normal! za")
	end)
end
o.statuscolumn = "%@v:lua.fold_click@%{v:lua.fold_icon()}%X%=%l %s"
o.winborder = "rounded"
o.termguicolors = true
o.scrolloff = 8
o.splitright = true
o.splitbelow = true

o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true

o.undofile = true
o.swapfile = false
o.confirm = true
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.updatetime = 250
o.timeoutlen = 300

o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevelstart = 99
