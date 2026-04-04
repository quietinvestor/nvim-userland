local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr }
	-- Go to definition
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
	-- Hover documentation
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
	-- Go to implementation
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
	-- Rename symbol
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
	-- Code actions
	vim.keymap.set(
		{ "n", "v" },
		"<leader>la",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", opts, { desc = "Code actions" })
	)
	-- Format code
	vim.keymap.set("n", "<leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
	-- Show diagnostics in a floating window
	vim.keymap.set(
		"n",
		"<leader>de",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
	)
	-- Send diagnostics to the quickfix list
	vim.keymap.set(
		"n",
		"<leader>dd",
		vim.diagnostic.setqflist,
		vim.tbl_extend("force", opts, { desc = "Diagnostics to quickfix" })
	)
	-- Go to previous diagnostic
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
	-- Go to next diagnostic
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
end

vim.keymap.set("n", "<leader>qo", "<cmd>copen 8<cr>", { desc = "Quickfix open" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Quickfix close" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix previous" })

return on_attach
