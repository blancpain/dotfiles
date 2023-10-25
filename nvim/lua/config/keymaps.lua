-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- write file
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Write" })

vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- better c-d and c-u and search
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })

vim.keymap.set("v", "<C-j>", ":MoveBlock(1)<cr>", { silent = true })
vim.keymap.set("v", "<C-k>", ":MoveBlock(-1)<cr>", { silent = true })
