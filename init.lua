-- Leader keys
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require("options")
require("keymaps")

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins.ui" },
		{ import = "plugins.editor" },
		{ import = "plugins.lsp" },
		-- { import = "plugins.git" },
		{ import = "plugins.treesitter" },
		-- { import = "plugins.utils" },
		-- { import = "plugins.lang" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
	change_detection = { notify = false },
})
