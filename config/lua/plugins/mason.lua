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
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig", -- Base LSP support
			"williamboman/mason.nvim", -- Ensure mason loads first
		},
		opts = {
			ensure_installed = {
				"bashls", -- Bash
				"clangd", -- C/C++
				"cmake", -- CMake
				"cssls", -- CSS
				"dockerls", -- Dockerfile
				"gopls", -- Go
				"html", -- HTML
				"ts_ls", -- TypeScript/JavaScript
				"jqls", -- JQ
				"jsonls", -- JSON
				"lua_ls", -- Lua
				"marksman", -- Markdown
				"puppet", -- Puppet
				"pyright", -- Python
				"sqls", -- SQL
				"terraformls", -- Terraform
				"yamlls", -- YAML
				"helm_ls", -- Helm
			},
			automatic_installation = true,
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
