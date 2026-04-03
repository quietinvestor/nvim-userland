local lspservers = require("config.lspservers")

return {
	{
		"williamboman/mason.nvim",
		lazy = false, -- Load during startup
		priority = 900, -- Load early, but after coloscheme
		opts = {
			-- Temporary workaround until Mason supports
			-- building cmake with python3.13
			PATH = "prepend",
			python = {
				executable_path = "/usr/bin/python3.12",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig", -- Base LSP support
			"williamboman/mason.nvim", -- Ensure mason loads first
		},
		opts = {
			ensure_installed = lspservers.lspconfig,
			automatic_enable = false,
		},
	},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			dependencies = {
				"williamboman/mason.nvim", -- Ensure mason loads first
			},
			opts = {
				ensure_installed = {
					-- Bash
					{ "shellcheck", version = "v0.11.0" }, -- linter
					{ "shfmt", version = "v3.13.0" }, -- formatter
					-- C/C++
					{ "clang-format", version = "22.1.2" }, -- formatter
					-- CSS
					{ "stylelint", version = "17.6.0" }, -- linter
					-- Docker
					{ "hadolint", version = "v2.14.0" }, -- linter
					-- Go
					{ "golangci-lint", version = "v2.11.4" }, -- linter
					{ "gofumpt", version = "v0.9.2" }, -- formatter
					-- HTML
					{ "htmlhint", version = "1.9.2" }, -- linter
					-- JavaScript/TypeScript
					{ "eslint_d", version = "15.0.2" }, -- linter (faster than eslint)
					-- JQ
					{ "jq", version = "jq-1.7" }, -- includes formatter
					-- JSON
					{ "jsonlint", version = "1.6.3" }, -- linter
					-- Lua
					{ "stylua", version = "v2.4.0" }, -- formatter
					{ "luacheck", version = "1.1.0" }, -- linter
					-- Markdown
					{ "markdownlint", version = "0.48.0" }, -- linter
					-- Python
					{ "ruff", version = "0.15.9" }, -- linter
					{ "black", version = "26.3.1" }, -- formatter
					{ "mypy", version = "1.20.0" }, -- type checker
					-- SQL
					{ "sqlfluff", version = "4.1.0" }, -- linter
					{ "sql-formatter", version = "15.7.3" }, -- formatter
					-- Terraform
					{ "tflint", version = "v0.61.0" }, -- linter
					-- YAML/Helm
					{ "yamllint", version = "1.38.0" }, -- linter
					{ "actionlint", version = "v1.7.12" }, -- linter
					-- Formatters (Prettier)
					{ "prettier", version = "3.8.1" }, -- formatter for CSS, HTML, JavaScript/TypeScript, JSON, Markdown, YAML
				},
				auto_update = false,
				run_on_start = false,
			},
	},
}
