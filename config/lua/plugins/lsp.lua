return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"williamboman/mason.nvim", -- Ensure mason loads first
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local on_attach = require("config.keymaps")

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("yamlls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "yaml", "github_actions" },
				settings = {
					yaml = {
						schemaStore = {
							enable = true,
						},
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://json.schemastore.org/github-action.json"] = "/.github/actions/**/action.yml",
						},
						validate = true,
						format = { enable = true },
						completion = {
							completeFullyQualifiedKinds = true,
						},
					},
				},
			})

			vim.lsp.config("puppet", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "puppet", "epuppet" },
			})

			local servers = {
				"bashls", -- Bash/Shell scripting
				"clangd", -- C/C++
				"cmake", -- CMake
				"cssls", -- CSS
				"dockerls", -- Dockerfile
				"gopls", -- Go
				"helm_ls", -- Helm
				"html", -- HTML
				"ts_ls", -- TypeScript/JavaScript
				"jqls", -- JQ
				"jsonls", -- JSON
				"marksman", -- Markdown
				"puppet", -- Puppet
				"pyright", -- Python
				"sqls", -- SQL
				"terraformls", -- Terraform/HCL
			}

			for _, lsp in ipairs(servers) do
				vim.lsp.config(lsp, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable(servers)
		end,
	},
}
