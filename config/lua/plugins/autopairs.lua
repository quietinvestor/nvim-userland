return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/nvim-cmp", -- Required for completion integration
	},
	config = function()
		-- Initialise autopairs
		require("nvim-autopairs").setup()
		-- Set up cmp integration
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
	-- use opts = {} for passing setup options
	-- this is equalent to setup({}) function
}
