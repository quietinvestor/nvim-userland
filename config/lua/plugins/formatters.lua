return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			bash = { "shfmt" },
			c = { "clang-format" },
			cmake = { "cmake_format" },
			css = { "prettier" },
			github_actions = { "prettier" },
			go = { "gofumpt" },
			html = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			python = { "black" },
			sql = { "sql_formatter" },
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
