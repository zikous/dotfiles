local prettier = { "prettier" }

require("conform").setup({
	formatters_by_ft = {
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		lua = { "stylua" },
		python = { "ruff_format" },
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		html = prettier,
		css = prettier,
		json = prettier,
		yaml = prettier,
		markdown = prettier,
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 1000,
	},
})

local lint = require("lint")
lint.linters_by_ft = {
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	python = { "ruff" },
}
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
	callback = function() lint.try_lint() end,
})
