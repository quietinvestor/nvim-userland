return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		opts = {
			defaults = {
				path_display = { "smart" },
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					initial_mode = "normal",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")

			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find files (hidden)" },
			{
				"<leader>fe",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
				desc = "File browser",
			},
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search current file" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		},
	},
}
