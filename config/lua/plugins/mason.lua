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
			ensure_installed = {
				"bash-language-server", -- bashls -- Bash
				"clangd", -- C/C++
				"css-lsp", -- cssls -- CSS
				"dockerfile-language-server", -- dockerls -- Dockerfile
				"gopls", -- Go
				"html-lsp", -- html -- HTML
				"typescript-language-server", -- ts_ls -- TypeScript/JavaScript
				"jq-lsp", -- jqls -- JQ
				"json-lsp", -- jsonls -- JSON
				"lua-language-server", -- lua_ls -- Lua
				"marksman", -- Markdown
				"puppet-editor-services", -- puppet -- Puppet
				"pyright", -- Python
				"sqls", -- SQL
				"terraform-ls", -- terraformls -- Terraform
				"yaml-language-server", -- yamlls -- YAML
				"helm-ls", -- helm_ls -- Helm
			},
			automatic_installation = true,
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
				"shellcheck", -- linter
				"shfmt", -- formatter
				-- C/C++
				"clang-format", -- formatter
				-- CMake
				"cmakelint", -- linter
				"cmakelang", -- formatter and linter
				-- CSS
				"stylelint", -- linter
				-- Docker
				"hadolint", -- linter
				-- Go
				"golangci-lint", -- linter
				"gofumpt", -- formatter
				-- HTML
				"htmlhint", -- linter
				-- JavaScript/TypeScript
				"eslint_d", -- linter (faster than eslint)
				-- JQ
				"jq", -- includes formatter
				-- JSON
				"jsonlint", -- linter
				-- Lua
				"stylua", -- formatter
				"luacheck", -- linter
				-- Markdown
				"markdownlint", -- linter
				-- Python
				"ruff", -- linter
				"black", -- formatter
				"mypy", -- type checker
				-- SQL
				"sqlfluff", -- linter
				"sql-formatter", -- formatter
				-- Terraform
				"tflint", -- linter
				-- YAML/Helm
				"yamllint", -- linter
				"actionlint", -- linter
				-- Formatters (Prettier)
				"prettier", -- formatter for CSS, HTML, JavaScript/TypeScript, JSON, Markdown, YAML
			},
			auto_update = true,
			run_on_start = true,
		},
	},
}
