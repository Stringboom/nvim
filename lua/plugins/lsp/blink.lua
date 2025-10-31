-- lua/plugins/lsp/blink.lua
return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	event = "InsertEnter",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	opts = {
		keymap = {
			preset = "default",
		},

		-- AUTO-TRIGGER: Show menu while typing
		trigger = {
			completion = {
				keyword = { "any" },
				show_on_trigger_character = true,
				min_keyword_length = 1,
			},
			signature_help = { enabled = true },
		},

		appearance = {
			nerd_font_source = true, -- Must be true
			kind_icons = {
				Text = "", -- Text
				Method = "", -- Method
				Function = "", -- Function
				Constructor = "", -- Constructor
				Field = "", -- Field
				Variable = "", -- Variable
				Class = "", -- Class
				Interface = "", -- Interface
				Module = "", -- Module
				Property = "", -- Property
				Unit = "", -- Unit
				Value = "", -- Value
				Enum = "", -- Enum
				Keyword = "", -- Keyword
				Snippet = "", -- Snippet
				Color = "", -- Color
				File = "", -- File
				Reference = "", -- Reference
				Folder = "", -- Folder
				EnumMember = "", -- EnumMember
				Constant = "", -- Constant
				Struct = "", -- Struct
				Event = "", -- Event
				Operator = "", -- Operator
				TypeParameter = "", -- TypeParameter
			},
		},

		sources = {
			default = { "lsp", "path", "buffer", "snippets" },
		},

		windows = {
			autocomplete = {
				border = "rounded",
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
			},
			documentation = { border = "rounded" },
		},

		fuzzy = { implementation = "rust" },
	},
}
