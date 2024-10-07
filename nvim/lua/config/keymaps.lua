local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-PageUp>", "<C-i>", opts) -- Temp workaround as C-i recognized as Tab in tmux

vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

-- remap increment/decrement
vim.keymap.set({ "n", "x" }, "+", "<C-a>", opts)
vim.keymap.set({ "n", "x" }, "_", "<C-x>", opts) -- technically not '-' but + still requires shift so no need to take finger off shift this way
-- remaps in visual mode as well
vim.keymap.set("x", "g+", "g<C-a>", opts)
vim.keymap.set("x", "g_", "g<C-x>", opts)

-- save and delete
vim.keymap.set({ "x", "n", "s" }, "<leader>w", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", LazyVim.ui.bufremove, { desc = "Delete Buffer" })

LazyVim.toggle.map("<leader>m", LazyVim.toggle.maximize)

-- exit insert mode with jj
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- better navigation and search;
vim.keymap.set("n", "<C-d>", "19jzz", opts)
vim.keymap.set("n", "<C-u>", "19kzz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

vim.keymap.set("x", "p", [["_dP]], opts) -- keep copied/deleted in register

-- moving to beginning/end of line
vim.keymap.set({ "n", "o", "x" }, "<S-h>", "^", opts)
vim.keymap.set({ "n", "o", "x" }, "<S-l>", "g_", opts)

-- tailwind bearable to work with
vim.keymap.set({ "n", "x" }, "j", "gj", opts)
vim.keymap.set({ "n", "x" }, "k", "gk", opts)

-- git
vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", opts)

-- NOTE: wezterm specific, not using as using TMUX atm

-- moving between wezterm panes
-- local nav = {
--   h = "Left",
--   j = "Down",
--   k = "Up",
--   l = "Right",
-- }
--
-- local function navigate(dir)
--   return function()
--     local win = vim.api.nvim_get_current_win()
--     vim.cmd.wincmd(dir)
--     local pane = vim.env.WEZTERM_PANE
--     if pane and win == vim.api.nvim_get_current_win() then
--       local pane_dir = nav[dir]
--       vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
--         if p.code ~= 0 then
--           vim.notify(
--             "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
--             vim.log.levels.ERROR,
--             { title = "Wezterm" }
--           )
--         end
--       end)
--     end
--   end
-- end
--
-- for key, dir in pairs(nav) do
--   vim.keymap.set("n", "<" .. dir .. ">", navigate(key))
--   vim.keymap.set("n", "<C-" .. key .. ">", navigate(key))
-- end
