return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"williamboman/mason.nvim", -- Ensure mason loads first
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- LSP Configuration
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Lua LSP specific configuration
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
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

			-- Configure other LSP servers
			local servers = {
				"bashls", -- Bash/Shell scripting
				"clangd", -- C/C++
				"cmake", -- CMake
				"cssls", -- CSS
				"dockerls", -- Dockerfile
				"gopls", -- Go
				"html", -- HTML
				"ts_ls", -- TypeScript/JavaScript
				"jqls", -- JQ
				"jsonls", -- JSON
				"marksman", -- Markdown
				"puppet", -- Puppet
				"pyright", -- Python
				"sqls", -- SQL
				"terraformls", -- Terraform/HCL
				"yamlls", -- YAML
				"helm_ls", -- Helm
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					capabilities = capabilities,
				})
			end
		end,
	},
}
