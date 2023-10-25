-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- write file - remove unused keymaps first
vim.api.nvim_del_keymap("n", "<leader>ww")
vim.api.nvim_del_keymap("n", "<leader>wd")
vim.api.nvim_del_keymap("n", "<leader>w-")
vim.api.nvim_del_keymap("n", "<leader>w|")

-- TODO: fix quitting + add better support for symbols outline/aerial - add constants etc...

-- close buffer - remove unused keymaps first
vim.api.nvim_del_keymap("n", "<leader>qd")
vim.api.nvim_del_keymap("n", "<leader>qq")
vim.api.nvim_del_keymap("n", "<leader>ql")
vim.api.nvim_del_keymap("n", "<leader>qs")

-- exit insert mode with jj
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- better c-d and c-u and search
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

vim.keymap.set("v", "<C-j>", ":MoveBlock(1)<cr>", { silent = true })
vim.keymap.set("v", "<C-k>", ":MoveBlock(-1)<cr>", { silent = true })
