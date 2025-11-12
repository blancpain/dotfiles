local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-PageUp>", "<C-i>", opts) -- Temp workaround as C-i recognized as Tab in tmux

vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

-- terminal toggling
vim.keymap.set("n", "<c-e>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
vim.keymap.set("t", "<c-e>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- remap increment/decrement
vim.keymap.set({ "n", "x" }, "+", "<C-a>", opts)
vim.keymap.set({ "n", "x" }, "_", "<C-x>", opts) -- technically not '-' but + still requires shift so no need to take finger off shift this way
-- remaps in visual mode as well
vim.keymap.set("x", "g+", "g<C-a>", opts)
vim.keymap.set("x", "g_", "g<C-x>", opts)

-- save and delete
vim.keymap.set({ "x", "n", "s" }, "<leader>w", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- maximmize and zen mode
Snacks.toggle.zoom():map("<leader>m"):map("<leader>uZ")
-- Snacks.toggle.zen():map("<leader>z")
--
-- better navigation and search;
vim.keymap.set("n", "<C-d>", "19jzz", opts)
vim.keymap.set("n", "<C-u>", "19kzz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

vim.keymap.set("x", "p", [["_dP]], opts) -- keep copied/deleted in register

-- pasting on new lines
vim.keymap.set("n", "gp", "o<Esc>p", { desc = "Paste on new line below" })
vim.keymap.set("n", "gP", "O<Esc>p", { desc = "Paste on new line above" })

-- moving to beginning/end of line
vim.keymap.set({ "n", "o", "x" }, "<S-h>", "^", opts)
vim.keymap.set({ "n", "o", "x" }, "<S-l>", "g_", opts)

-- git
vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", opts)
