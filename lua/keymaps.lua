local keymap = vim.keymap.set

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows with arrows (no floating cmdline)
keymap("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
keymap("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Clear search highlighting
keymap("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Stay in indent mode (duplicate safety)
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste without yanking
keymap("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- Telescope
keymap("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Help tags" })
keymap("n", "<leader>fr", "<Cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fc", "<Cmd>Telescope grep_string<CR>", { desc = "Grep string under cursor" })
keymap("n", "<leader>fk", "<Cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
keymap("n", "<leader>fs", "<Cmd>Telescope git_status<CR>", { desc = "Git status" })
keymap("n", "<leader>fd", "<Cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

-- Save file with Ctrl+s (Noice-safe)
keymap("n", "<C-s>", "<Cmd>write<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><Cmd>write<CR>gi", { desc = "Save file (insert mode)" })
keymap("v", "<C-s>", "<Esc><Cmd>write<CR>gv", { desc = "Save file (visual mode)" })

-- Close buffer with leader c
keymap("n", "<leader>c", "<Cmd>bd<CR>", { desc = "Close buffer" })

-- Close nvim with leader q
keymap("n", "<leader>q", "<Cmd>qa<CR>", { desc = "Quit nvim" })
keymap("n", "<leader>Q", "<Cmd>qa!<CR>", { desc = "Force quit nvim" })
