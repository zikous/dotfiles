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

-- rust_analyzer is managed by rustaceanvim
vim.lsp.enable({
	"clangd", "ts_ls", "html", "cssls", "bashls",
	"lua_ls", "pyright", "jsonls", "yamlls", "texlab",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("gr", Snacks.picker.lsp_references, "References")
		map("gi", Snacks.picker.lsp_implementations, "Implementations")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
		end, "Toggle inlay hints")
	end,
})
