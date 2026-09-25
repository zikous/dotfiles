vim.g.mapleader = " "

-- plugins
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data
		if data.spec.name == "nvim-treesitter" and data.kind == "update" then
			if not data.active then vim.cmd.packadd("nvim-treesitter") end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add {
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://codeberg.org/andyg/leap.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}

-- options
vim.cmd.colorscheme "catppuccin-nvim"
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- number/relativenumber are window-local; explorer/tree windows (e.g.
-- snacks) turn them off, so re-assert on every real file buffer
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
	callback = function()
		if vim.bo.buftype == "" then
			vim.wo.number = true
			vim.wo.relativenumber = true
		end
	end,
})

-- plugin setup
require("lualine").setup({
	sections = {
		lualine_x = { "encoding", "filetype" },
	},
})

require("tiny-inline-diagnostic").setup({
	options = {
		multilines = {
			enabled = true,
		},
	},
	preset = "ghost",
})

require("smear_cursor").setup({
	stiffness = 0.8,
	trailing_stiffness = 0.6,
	stiffness_insert_mode = 0.7,
	trailing_stiffness_insert_mode = 0.7,
	damping = 0.95,
	damping_insert_mode = 0.95,
	distance_stop_animating = 0.5,
})

require("nvim-autopairs").setup {}

require("gitsigns").setup({
	signs = {
		add          = { text = "+" },
		change       = { text = "~" },
		delete       = { text = "_" },
		topdelete    = { text = "‾" },
		changedelete = { text = "~" },
		untracked    = { text = "┆" },
	},
})

require("conform").setup({
	formatters_by_ft = {
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 1000,
	},
})

require("nvim-treesitter").install({
	"c", "cpp", "rust", "lua", "python", "typescript", "tsx", "javascript",
	"html", "css", "json", "yaml", "bash", "markdown", "latex",
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

require("snacks").setup({
	picker = { enabled = true },
	explorer = { enabled = true },
	lazygit = { enabled = true },
})

-- fix: snacks passes full path to devicons, breaking filename-only icons (folke/snacks.nvim#2597)
-- TODO: remove this patch once the upstream issue is fixed
do
	local util = require("snacks.util")
	local orig_icon = util.icon
	local get_icon = require("nvim-web-devicons").get_icon
	util.icon = function(name, cat, opts)
		if cat == "file" or cat == nil then
			local basename = vim.fs.basename(name)
			local icon, hl = get_icon(basename, basename:match("%.(%w+)$"), { default = false })
			if icon then
				return icon, hl
			end
		end
		return orig_icon(name, cat, opts)
	end
end

-- lsp
local diagnostic_icon = "●"
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_icon,
			[vim.diagnostic.severity.WARN]  = diagnostic_icon,
			[vim.diagnostic.severity.INFO]  = diagnostic_icon,
			[vim.diagnostic.severity.HINT]  = diagnostic_icon,
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "Snacks" },
			},
		},
	},
})

vim.lsp.enable({
	"rust_analyzer", "clangd", "ts_ls", "html", "cssls", "bashls",
	"lua_ls", "pyright", "jsonls", "yamlls", "texlab",
})

-- keymaps
local map = vim.keymap.set
local gitsigns = require("gitsigns")

map("n", "<leader>ff", Snacks.picker.files)
map("n", "<leader>fg", Snacks.picker.grep)
map("n", "<leader>fb", Snacks.picker.buffers)
map("n", "<leader>fd", Snacks.picker.diagnostics)
map("n", "<leader>fs", Snacks.picker.lsp_symbols)
map("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols)
map("n", "<leader>fe", function() Snacks.explorer() end)
map("n", "<leader>fm", function() require("conform").format({ lsp_format = "fallback" }) end)
map("n", "gd", Snacks.picker.lsp_definitions)

map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap jump on current window" })
map("n", "S", "<Plug>(leap-from-window)", { desc = "Leap jump on other windows" })

map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })

map("n", "<leader>wH", "<cmd>vertical resize -5<cr>", { desc = "Narrow window" })
map("n", "<leader>wL", "<cmd>vertical resize +5<cr>", { desc = "Widen window" })
map("n", "<leader>wK", "<cmd>resize +3<cr>", { desc = "Taller window" })
map("n", "<leader>wJ", "<cmd>resize -3<cr>", { desc = "Shorter window" })

map("n", "<leader>lg", function() Snacks.lazygit() end)
map("n", "<leader>gh", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gitsigns.nav_hunk("next")
	end
end)
map("n", "<leader>gH", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gitsigns.nav_hunk("prev")
	end
end)
map("n", "<leader>gs", gitsigns.stage_hunk)
map("n", "<leader>gu", gitsigns.reset_hunk)
map("n", "<leader>gp", gitsigns.preview_hunk)
map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end)
