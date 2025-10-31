-- Mason + Conform + auto-install formatters
return {
	-- ────────────────────────────────────────
	-- 1. Mason – LSP / formatter installer
	-- ────────────────────────────────────────
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		opts = {},
	},

	-- ────────────────────────────────────────
	-- 2. Conform – format on save
	-- ────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "black", "isort" },
				rust = { "rustfmt" },
				go = { "gofmt", "goimports" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				dockerfile = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
			formatters = {
				prettier = {
					prepend_args = function()
						local cfg = vim.fs.find({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.js",
							".prettierrc.cjs",
							"prettier.config.js",
							"prettier.config.cjs",
						}, { upward = true })[1]
						return cfg and { "--config", cfg } or {}
					end,
				},
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			-- <leader>F = format current buffer (or selection in visual mode)
			vim.keymap.set({ "n", "v" }, "<leader>F", function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "Format with Conform" })
		end,
	},

	-- ────────────────────────────────────────
	-- 3. Auto-install formatters defined in Conform
	-- ────────────────────────────────────────
	{
		"zapling/mason-conform.nvim",
		dependencies = { "williamboman/mason.nvim", "stevearc/conform.nvim" },
		config = true,
	},
}
