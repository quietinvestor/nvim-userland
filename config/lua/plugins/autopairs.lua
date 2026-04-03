return {
	"nvim-mini/mini.pairs",
	version = "v0.17.0",
	event = "InsertEnter",
	config = function()
		require("mini.pairs").setup()
	end,
}
