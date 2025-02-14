vim.opt.list = false
vim.o.swapfile = false -- disable swapfile
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.timeoutlen = 300
vim.o.background = "dark" -- dark vs light
-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" }) -- WARN: doesn't work as expected
vim.opt.clipboard = "unnamedplus"
vim.g.snacks_animate = false

-- default picker
vim.g.lazyvim_picker = "snacks"
