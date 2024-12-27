-- Set GitHub actions file type detection
vim.filetype.add({
	pattern = {
		[".*/%.github/workflows/.*%.ya?ml"] = "github_actions",
		[".*/%.github/actions/.*%.ya?ml"] = "github_actions",
	},
})

-- Set Helm file type detection
vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
	},
	pattern = {
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.ya?ml"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
	},
})

-- Language-specific indentation settings
local indentation = {
	[2] = {
		"css",
		"helm",
		"html",
		"javascript",
		"json",
		"lua",
		"puppet",
		"query",
		"terraform",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	},
	[4] = {
		"bash",
		"c",
		"cmake",
		"docker",
		"go",
		"gotmpl",
		"jq",
		"markdown",
		"markdown_inline",
		"python",
		"sql",
	},
}

local function set_buffer_indent(bufnr, ft)
	for spaces, filetypes in pairs(indentation) do
		if vim.tbl_contains(filetypes, ft) then
			vim.bo[bufnr].shiftwidth = spaces
			vim.bo[bufnr].tabstop = spaces
			break -- No need to check other space values
		end
	end
end

-- Set up autocommand for future buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		set_buffer_indent(args.buf, args.match)
	end,
})

-- Handle already-opened buffers
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	set_buffer_indent(bufnr, vim.bo[bufnr].filetype)
end
