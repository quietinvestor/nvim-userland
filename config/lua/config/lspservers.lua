local servers = {
	{ server = "bashls", mason = "bash-language-server", version = "5.6.0" },
	{ server = "clangd", mason = "clangd", version = "22.1.0" },
	{ server = "cssls", mason = "css-lsp", version = "4.10.0" },
	{ server = "dockerls", mason = "dockerfile-language-server", version = "0.15.0" },
	{ server = "gopls", mason = "gopls", version = "v0.21.1" },
	{ server = "helm_ls", mason = "helm-ls", version = "v0.5.4" },
	{ server = "html", mason = "html-lsp", version = "4.10.0" },
	{ server = "jqls", mason = "jq-lsp", version = "v0.1.17" },
	{ server = "jsonls", mason = "json-lsp", version = "4.10.0" },
	{ server = "lua_ls", mason = "lua-language-server", version = "3.17.1" },
	{ server = "marksman", mason = "marksman", version = "2026-02-08" },
	{ server = "puppet", mason = "puppet-editor-services", version = "v2.0.4" },
	{ server = "pyright", mason = "pyright", version = "1.1.408" },
	{ server = "sqls", mason = "sqls", version = "v0.2.46" },
	{ server = "terraformls", mason = "terraform-ls", version = "v0.38.6" },
	{ server = "ts_ls", mason = "typescript-language-server", version = "5.1.3" },
	{ server = "yamlls", mason = "yaml-language-server", version = "1.21.0" },
}

return {
	all = servers,
	lspconfig = vim.tbl_map(function(entry)
		return entry.server
	end, servers),
	mason = vim.tbl_map(function(entry)
		return string.format("%s@%s", entry.mason, entry.version)
	end, servers),
}
