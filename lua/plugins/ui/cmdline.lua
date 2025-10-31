-- Simple floating command-line (:)
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- optional, but makes notifications pretty
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup", -- floating window
			opts = {},
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
			},
		},
		popupmenu = {
			enabled = false, -- we use blink.cmp
		},
		messages = {
			enabled = false, -- disable message area
		},
		notify = {
			enabled = false, -- use nvim-notify instead
		},
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = false,
			inc_rename = false,
			lsp_doc_border = false,
		},
		views = {
			cmdline_popup = {
				position = { row = 5, col = "50%" },
				size = { width = 60, height = "auto" },
				border = { style = "rounded" },
				win_options = {
					winhighlight = {
						Normal = "NormalFloat",
						FloatBorder = "FloatBorder",
					},
				},
			},
		},
	},
}
