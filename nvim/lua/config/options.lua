vim.opt.list = false
vim.o.swapfile = false -- disable swapfile
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.timeoutlen = 200

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" }) -- WARN: doesn't work as expected
