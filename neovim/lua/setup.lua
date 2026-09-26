-- ui
require("lualine").setup({
	sections = {
		lualine_x = { "encoding", "filetype" },
	},
})

require("tiny-inline-diagnostic").setup({
	options = { multilines = { enabled = true } },
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

require("which-key").setup {}
require("render-markdown").setup {}

require("snacks").setup({
	picker = { enabled = true },
	explorer = { enabled = true },
	lazygit = { enabled = true },
	indent = { enabled = true },
	words = { enabled = true },
	terminal = { enabled = true },
	notifier = { enabled = true },
	bigfile = { enabled = true },
	input = { enabled = true },
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

-- editing
require("nvim-autopairs").setup {}
require("nvim-surround").setup {}
require("nvim-ts-autotag").setup {}
require("todo-comments").setup {}
require("treesj").setup({ use_default_keymaps = false })
require("autoread").setup()

local bar = "┃"
require("gitsigns").setup({
	signs = {
		add          = { text = bar },
		change       = { text = bar },
		delete       = { text = "▁" },
		topdelete    = { text = "▔" },
		changedelete = { text = bar },
		untracked    = { text = bar },
	},
})

-- treesitter
require("nvim-treesitter").install({
	"c", "cpp", "rust", "lua", "python", "typescript", "tsx", "javascript",
	"html", "css", "json", "yaml", "bash", "markdown", "markdown_inline", "latex",
})
require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
})

-- completion
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
		accept = { auto_brackets = { enabled = true } },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})
