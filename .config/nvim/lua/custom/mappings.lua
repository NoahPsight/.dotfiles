return {
  disabled = {
    n = {
      ["<leader>fm"] = "",
    },
  },
  my_custom = {
    n = {
      ["J"] = { "mzJ`z", "Join lines and restore cursor position" },
      ["<C-d>"] = { "<C-d>zz", "Scroll down half a page and recenter" },
      ["<C-u>"] = { "<C-u>zz", "Scroll up half a page and recenter" },
      ["n"] = { "nzzzv", "Find next and recenter" },
      ["N"] = { "Nzzzv", "Find previous and recenter" },
      ["<C-s>"] = {
        function()
          vim.lsp.buf.format { async = true }
          vim.cmd "write"
        end,
        "LSP Format + Save",
      },
    },
    v = {
      ["J"] = { ":m '>+1<CR>gv=gv", "Move visual selection down" },
      ["K"] = { ":m '<-2<CR>gv=gv", "Move visual selection up" },
    },
  },
  crates = {
    plugin = true,
    n = {
      ["<leader>rcu"] = {
        function()
          require("crates").upgrade_all_crates()
        end,
        "update crates",
      },
    },
  },
}
