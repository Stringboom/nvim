-- Simple, clean Telescope setup
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
		{ "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume" },
	},
	opts = {
		defaults = {
			layout_strategy = "vertical",
			layout_config = { height = 0.95, width = 0.95 },
			mappings = {
				i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
			},
		},
		pickers = {
			find_files = { theme = "dropdown" },
			live_grep = { theme = "ivy" },
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
