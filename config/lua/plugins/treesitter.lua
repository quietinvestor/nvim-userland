local treesitter = require("config.treesitter")

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	config = function()
		require("nvim-treesitter").setup({})

		vim.treesitter.language.register("yaml", "github_actions")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = treesitter.parsers,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
