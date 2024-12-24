-- Vim options - Need to be set both at the global level
-- and their default scope as per help, e.g. :h cursorline
vim.go.cursorline = true -- Highlight selected line
vim.wo.cursorline = true
vim.go.expandtab = true -- Spaces are used in indents
vim.bo.expandtab = true
vim.go.number = true -- Add line numbers
vim.wo.number = true
vim.go.shiftwidth = 4 -- Use 4 spaces for indentation
vim.bo.shiftwidth = 4
vim.go.tabstop = 4 -- Use 4 spaces when tab is pressed
vim.bo.tabstop = 4

-- Set Helm file type detection
vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
	},
	pattern = {
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.ya?ml"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
	},
})

-- Language-specific indentation settings
local indentation = {
	[2] = {
		"css",
		"helm",
		"html",
		"javascript",
		"json",
		"lua",
		"puppet",
		"query",
		"terraform",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	},
	[4] = {
		"bash",
		"c",
		"cmake",
		"docker",
		"go",
		"gotmpl",
		"jq",
		"markdown",
		"markdown_inline",
		"python",
		"sql",
	},
}

local function set_buffer_indent(bufnr, ft)
	for spaces, filetypes in pairs(indentation) do
		if vim.tbl_contains(filetypes, ft) then
			vim.bo[bufnr].shiftwidth = spaces
			vim.bo[bufnr].tabstop = spaces
			break -- No need to check other space values
		end
	end
end

-- Set up autocommand for future buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		set_buffer_indent(args.buf, args.match)
	end,
})

-- Handle already-opened buffers
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	set_buffer_indent(bufnr, vim.bo[bufnr].filetype)
end

-- LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
	print("Done.")
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/tokyonight.nvim" },
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				auto_install = true,
				ensure_installed = {
					"bash",
					"c",
					"cmake",
					"css",
					"dockerfile",
					"go",
					"gotmpl",
					"hcl",
					"helm",
					"html",
					"javascript",
					"json",
					"jq",
					"lua",
					"markdown",
					"markdown_inline",
					"puppet",
					"python",
					"query",
					"sql",
					"vim",
					"vimdoc",
					"yaml",
				},
				highlight = { enable = true },
				ignore_install = {},
				indent = { enable = true },
				modules = {},
				sync_install = false,
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
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
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				c = { "clang-format" },
				cmake = { "cmake_format" },
				css = { "prettier" },
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
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
})

-- Set colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight")

---
-- LSP Configuration
---
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Only set up essential keymaps
local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr }
	-- Go to definition
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- Hover documentation
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- Go to implementation
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- Rename symbol
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	-- Code actions
	vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
	-- Format code
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	-- Show diagnostics in a floating window
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	-- Go to previous diagnostic
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	-- Go to next diagnostic
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	-- Show diagnostic list in quickfix window
	vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist, opts)
end

-- Mason Setup
require("mason").setup({
	-- Temporary workaround until Mason supports
	-- building cmake with python3.13
	PATH = "prepend",
	python = {
		executable_path = "/usr/bin/python3.12",
	},
})

require("mason-lspconfig").setup({
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
})

-- Linters and formatters need mason-tool-installer
require("mason-tool-installer").setup({
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
})

-- Configure LSP servers
local lspconfig = require("lspconfig")

-- Lua LSP specific configuration
lspconfig.lua_ls.setup({
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
	"jqls", -- JQ (JSON query language)
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
		on_attach = on_attach,
	})
end

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
})

-- nvim-autopairs integration with cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
