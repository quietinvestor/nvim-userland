return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lint").linters.helm = {
			cmd = "helm",
			stdin = false,
			args = { "lint" },
			stream = "both",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %trror: %m", {
				source = "helm lint",
				severity = vim.diagnostic.severity.ERROR,
			}),
		}

		require("lint").linters_by_ft = {
			bash = { "shellcheck" },
			c = { "clangtidy" },
			cpp = { "clangtidy" },
			css = { "stylelint" },
			dockerfile = { "hadolint" },
			github_actions = { "yamllint", "actionlint" },
			go = { "golangcilint" },
			helm = { "helm" },
			html = { "htmlhint" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			json = { "jsonlint" },
			lua = { "luacheck" },
			markdown = { "markdownlint" },
			python = { "ruff", "mypy" },
			sql = { "sqlfluff" },
			terraform = { "tflint" },
			yaml = { "yamllint" },
		}

		-- Create an autocommand to trigger linting
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
