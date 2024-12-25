local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr }
	-- Go to definition
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- Hover documentation
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- Go to implementation
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- Rename symbol
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	-- Code actions
	vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
	-- Format code
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	-- Show diagnostics in a floating window
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	-- Go to previous diagnostic
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	-- Go to next diagnostic
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	-- Show diagnostic list in quickfix window
	vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist, opts)
end

return on_attach
