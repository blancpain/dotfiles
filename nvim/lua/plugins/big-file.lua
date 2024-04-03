local M = {
  "blancpain/bigfile.nvim",
}

function M.config()
  require("bigfile").setup({

    pattern = function(bufnr, filesize_mib)
      -- you can't use `nvim_buf_line_count` because this runs on BufReadPre
      local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
      local file_length = #file_contents
      local filetype = vim.filetype.match({ buf = bufnr })
      if file_length > 2000 and (filetype == "javascript" or filetype == "typescript") then
        return true
      end
    end,

    features = {
      "indent-blankline",
    },
  })
end

return M
