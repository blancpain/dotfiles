-- when switching configs: 
-- mv ~/.local/share/nvim{,.bak}
-- mv ~/.local/state/nvim{,.bak}
-- mv ~/.cache/nvim{,.bak}

require("user.launch")
require("user.options")
require("user.keymaps")
spec("user.colorscheme")
spec("user.devicons")
spec("user.treesitter")
spec("user.mason")
require("user.lazy")
