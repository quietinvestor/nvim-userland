local lspservers = require("config.lspservers")

return {
	{
		"mason-org/mason.nvim",
		version = "v2.2.1",
		lazy = false, -- Load during startup
		priority = 900, -- Load early, but after coloscheme
		opts = {
			PATH = "prepend",
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		version = "v2.1.0",
		dependencies = {
			"neovim/nvim-lspconfig", -- Base LSP support
			"mason-org/mason.nvim", -- Ensure mason loads first
		},
		opts = {
			ensure_installed = lspservers.lspconfig,
			automatic_enable = false,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim", -- Ensure mason loads first
		},
		opts = {
			ensure_installed = {
				-- Bash
				{ "shellcheck", version = "v0.11.0" }, -- linter
				{ "shfmt", version = "v3.13.0" }, -- formatter
				{ "basedpyright", version = "1.38.2" }, -- Python LSP
				{ "biome", version = "2.4.9" }, -- JS/TS/CSS/JSON formatter+linter
				-- C/C++
				{ "clang-format", version = "22.1.2" }, -- formatter
				-- Docker
				{ "hadolint", version = "v2.14.0" }, -- linter
				-- Go
				{ "golangci-lint", version = "v2.11.4" }, -- linter
				{ "gofumpt", version = "v0.9.2" }, -- formatter
				-- HTML
				{ "htmlhint", version = "1.9.2" }, -- linter
				-- Lua
				{ "selene", version = "0.29.0" }, -- linter
				{ "stylua", version = "v2.4.0" }, -- formatter
				-- Markdown
				{ "markdownlint", version = "0.48.0" }, -- linter
				{ "markdown-oxide", version = "v0.25.10" }, -- Markdown LSP
				-- Python
				{ "ruff", version = "0.15.9" }, -- linter
				{ "black", version = "26.3.1" }, -- formatter
				{ "mypy", version = "1.20.0" }, -- type checker
				-- SQL
				{ "sqlfluff", version = "4.1.0" }, -- linter
				{ "sql-formatter", version = "15.7.3" }, -- formatter
				-- Terraform
				{ "tflint", version = "v0.61.0" }, -- linter
				{ "vtsls", version = "0.2.9" }, -- TypeScript/JavaScript LSP
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
