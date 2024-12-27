return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"css",
				"dockerfile",
				"go",
				"gotmpl",
				"hcl",
				"helm",
				"html",
				"javascript",
				"json",
				"jq",
				"lua",
				"markdown",
				"markdown_inline",
				"puppet",
				"python",
				"query",
				"sql",
				"vim",
				"vimdoc",
				"yaml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			ignore_install = {},
			indent = { enable = true },
			modules = {},
			sync_install = false,
		})
		vim.treesitter.language.register("yaml", "github_actions")
	end,
}
