return {
  "tadmccorkle/markdown.nvim",
  ft = "markdown", -- or 'event = "VeryLazy"'
  opts = {
    mappings = {
      inline_surround_toggle = "gms", -- (string|boolean) toggle inline style
      inline_surround_toggle_line = "gmss", -- (string|boolean) line-wise toggle inline style
      inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
      inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
      link_add = "gl", -- (string|boolean) add link
      link_follow = false,
      go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
      go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
      go_next_heading = "]\\", -- (string|boolean) set cursor to next section heading
      go_prev_heading = "[p", -- (string|boolean) set cursor to previous section heading
    },
  },
}
