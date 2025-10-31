-- LSP servers – with blink.cmp integration
return {
	"neovim/nvim-lspconfig",
	dependencies = { "williamboman/mason-lspconfig.nvim" },
	event = "BufReadPre",
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
					},
				},
			},
			ts_ls = {},
			pyright = {},
			rust_analyzer = {},
		},
	},
	config = function(_, opts)
		vim.deprecate = function() end

		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- BLINK.CMP: Enhance capabilities
		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		-- Auto-install
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(opts.servers),
			automatic_installation = true,
		})

		-- Setup servers
		for server, server_opts in pairs(opts.servers) do
			server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
			lspconfig[server].setup(server_opts)
		end

		-- Keymaps on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
				end
				bufmap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
				bufmap("n", "K", vim.lsp.buf.hover, "Hover")
				bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
			end,
		})
	end,
}
