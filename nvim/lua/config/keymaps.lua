local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-i>", "<C-i>", opts) -- needed as sometimes overlaps w/ Tab

-- remap increment/decrement
vim.keymap.set({ "n", "x" }, "+", "<C-a>", opts)
vim.keymap.set({ "n", "x" }, "_", "<C-x>", opts) -- technically not '-' but + still requires shift so no need to take finger off shift this way
-- remaps in visual mode as well
vim.keymap.set("x", "g+", "g<C-a>", opts)
vim.keymap.set("x", "g_", "g<C-x>", opts)

--remove unused default keymaps
vim.api.nvim_del_keymap("n", "<leader>ww")
vim.api.nvim_del_keymap("n", "<leader>wd")
vim.api.nvim_del_keymap("n", "<leader>w-")
vim.api.nvim_del_keymap("n", "<leader>w|")
vim.api.nvim_del_keymap("n", "<leader>qq")

-- exit insert mode with jj
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- better navigation and search;
vim.keymap.set("n", "<C-d>", "19jzz", opts)
vim.keymap.set("n", "<C-u>", "19kzz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

vim.keymap.set("x", "p", [["_dP]], opts) -- keep copied/deleted in register

-- moving to beginning/end of line
vim.keymap.set({ "n", "o", "x" }, "<s-h>", "^", opts)
vim.keymap.set({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- tailwind bearable to work with
vim.keymap.set({ "n", "x" }, "j", "gj", opts)
vim.keymap.set({ "n", "x" }, "k", "gk", opts)

-- chatgpt
-- vim.keymap.set("n", "<leader>gp", "<cmd>ChatGPT<cr>", { desc = "Launch ChatGPT" })
-- vim.keymap.set("n", "<leader>gpa", "<cmd>ChatGPTActAs<cr>", { desc = "ChatGPT Act As" })
-- vim.keymap.set("n", "<leader>gpe", "<cmd>ChatGPTEditWithInstructions<cr>", { desc = "ChatGPT Edit With Instructions" })
-- vim.keymap.set("n", "<leader>gpc", "<cmd>ChatGPTCompleteCode<cr>", { desc = "ChatGPT Complete Code" })
-- vim.keymap.set("n", "<leader>gpf", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "ChatGPT Fix Bugs" })
-- vim.keymap.set("n", "<leader>gpx", "<cmd>ChatGPTRun explain_code<cr>", { desc = "ChatGPT Explain Code" })

-- markdown specific
-- vim.keymap.set("x", "<leader>mb", "di****<esc>hhp", { desc = "Auto bold" })
-- vim.keymap.set("x", "<leader>mi", "di**<esc>hp", { desc = "Auto italic" })
-- vim.keymap.set("x", "<leader>ml", "di[]()<esc>hhhpllli", { desc = "Auto link" })
-- vim.keymap.set("x", "<leader>mc", "di``<esc>hp", { desc = "Auto backtick" })
--vim.keymap.set("x", "<leader>ms", "di~~~~<esc>hp", { desc = "Auto strikethrough" })

-- git
-- vim.api.nvim_set_keymap("n", "<leader>gm", ':Git commit -m "', { noremap = false })

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
