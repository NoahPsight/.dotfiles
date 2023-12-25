local function format_and_save()
  vim.lsp.buf.format { async = true }
  vim.cmd "write"
end

return {
  disabled = {
    n = {
      ["<leader>fm"] = "",
    },
  },
  my_custom = {
    n = {
      ["<C-s>"] = { format_and_save, "LSP Format + Save" },
      ["J"] = { "mzJ`z", "Join lines and restore cursor position" },
      ["<C-d>"] = { "<C-d>zz", "Scroll down half a page and recenter" },
      ["<C-u>"] = { "<C-u>zz", "Scroll up half a page and recenter" },
      ["n"] = { "nzzzv", "Find next and recenter" },
      ["N"] = { "Nzzzv", "Find previous and recenter" },
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
