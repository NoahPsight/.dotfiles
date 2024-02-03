return {
  "tpope/vim-fugitive",
  lazy = false,
  init = function()
    local map = require "custom.mappings"
    map.fugitive = {
      n = {
        ["<leader>gs"] = { "<cmd> G <CR>", "Git Status" },
        ["<leader>gl"] = {
          "<cmd> Git log --all --decorate --oneline --graph <CR>",
          "Git Log",
        },
        ["<leader>gL"] = { "<cmd> GlLog <CR>", "Git Advanced Log" },
        ["<leader>gf"] = { "<cmd> Git fetch <CR>", "Git Fetch" },
        ["<leader>gp"] = { "<cmd> Git pull <CR>", "Git Pull" },
        ["<leader>gP"] = { "<cmd> Git push <CR>", "Git Push" },
        ["<leader>gr"] = { "<cmd> Git rebase -i --root <CR>", "Git Rebase" },
        ["<leader>gc"] = {
          "<cmd> Telescope git_branches <CR>",
          "Git Checkout",
        },
      },
    }
  end,
}
