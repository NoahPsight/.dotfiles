return {
  "alexghergh/nvim-tmux-navigation",
  lazy = false,
  init = function()
    local map = require "custom.mappings"
    local nav = require "nvim-tmux-navigation"
    map.general.n["<C-h>"] = { nav.NvimTmuxNavigateLeft, "Window Left" }
    map.general.n["<C-j>"] = { nav.NvimTmuxNavigateDown, "Window Down" }
    map.general.n["<C-k>"] = { nav.NvimTmuxNavigateUp, "Window Up" }
    map.general.n["<C-l>"] = { nav.NvimTmuxNavigateRight, "Window Right" }
    map.disabled.n["<C-h>"] = ""
    map.disabled.n["<C-l>"] = ""
    map.disabled.n["<C-j>"] = ""
    map.disabled.n["<C-k>"] = ""
  end,
}
