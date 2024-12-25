return {
	"folke/tokyonight.nvim",
	lazy = false, -- Load during startup
	priority = 1000, -- Highest priority to load first
	config = function()
		vim.cmd([[colorscheme tokyonight]])
	end,
}
