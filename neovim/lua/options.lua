local o = vim.opt

vim.cmd.colorscheme "catppuccin-nvim"

o.showmode = false
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
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
