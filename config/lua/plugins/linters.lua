return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lint").linters_by_ft = {
			bash = { "shellcheck" },
			c = { "clangd" },
			cmake = { "cmakelint", "cmakelang" },
			css = { "stylelint" },
			dockerfile = { "hadolint" },
			go = { "golangcilint" },
			html = { "htmlhint" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			json = { "jsonlint" },
			lua = { "luacheck" },
			markdown = { "markdownlint" },
			python = { "ruff", "mypy" },
			sql = { "sqlfluff" },
			terraform = { "tflint" },
			yaml = { "yamllint", "actionlint" },
		}

		-- Create an autocommand to trigger linting
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
