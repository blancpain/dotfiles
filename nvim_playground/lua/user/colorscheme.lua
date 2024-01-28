local M = {
	"rebelot/kanagawa.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	transparent = true,
}

function M.config()
	require("kanagawa").setup({
		transparent = true,
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
	})
	vim.cmd.colorscheme("kanagawa-wave")
end

return M
