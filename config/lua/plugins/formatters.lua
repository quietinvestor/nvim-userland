return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			bash = { "shfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			css = { "biome" },
			github_actions = { "prettier" },
			go = { "gofumpt" },
			helm = { "prettier" },
			html = { "prettier" },
			javascript = { "biome" },
			javascriptreact = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			json = { "biome" },
			jsonc = { "biome" },
			lua = { "stylua" },
			markdown = { "prettier" },
			python = { "black" },
			puppet = { "puppet-lint" },
			sql = { "sql_formatter" },
			terraform = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
			yaml = { "prettier" },
		},
		-- Set up format-on-save
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "4", "-ci" }, -- Use 4 spaces, indent switch cases
			},
			black = {
				prepend_args = { "--line-length", "79" }, -- PEP8 standard
			},
			prettier = {
				prepend_args = { "--print-width", "80" }, -- Standard width, tab width will be determined by file type
			},
		},
	},
}
