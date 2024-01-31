local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-i>", "<C-i>", opts) -- needed as sometimes overlaps w/ Tab

--remove unused default keymaps
vim.api.nvim_del_keymap("n", "<leader>ww")
vim.api.nvim_del_keymap("n", "<leader>wd")
vim.api.nvim_del_keymap("n", "<leader>w-")
vim.api.nvim_del_keymap("n", "<leader>w|")
vim.api.nvim_del_keymap("n", "<leader>qq")

-- exit insert mode with jj
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- better c-d and c-u and search
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- vim.keymap.set("v", "<C-j>", ":MoveBlock(1)<cr>", { silent = true })
-- vim.keymap.set("v", "<C-k>", ":MoveBlock(-1)<cr>", { silent = true })

vim.keymap.set("x", "p", [["_dP]], opts) -- keep copied/deleted in register

-- moving to beginning/end of line
vim.keymap.set({ "n", "o", "x" }, "<s-h>", "^", opts)
vim.keymap.set({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- tailwind bearable to work with
vim.keymap.set({ "n", "x" }, "j", "gj", opts)
vim.keymap.set({ "n", "x" }, "k", "gk", opts)
