return {
  "echasnovski/mini.comment",
  opts = {
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = "<Leader>/",

      -- Toggle comment on current line
      comment_line = "<Leader>/",

      -- Toggle comment on visual selection
      comment_visual = "<Leader>/",

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      textobject = "<Leader>/",
    },
  },
}
