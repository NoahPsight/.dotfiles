return {
  disabled = {
    n = {
      -- ["<leader>fm"] = "",
      ["<leader>gt"] = "",
    },
  },
  general = {
    n = {
      -- ["<C-s>"] = { "<cmd> w <CR>", "Format and Save file" },
      ["J"] = { "mzJ`z", "Join lines and restore cursor position" },
      ["<C-d>"] = { "<C-d>zz", "Scroll down half a page and recenter" },
      ["<C-u>"] = { "<C-u>zz", "Scroll up half a page and recenter" },
      ["n"] = { "nzzzv", "Find next and recenter" },
      ["N"] = { "Nzzzv", "Find previous and recenter" },
      ["*"] = { "*zz", "Search word under cursor and recenter" },
    },
    v = {
      ["J"] = { ":m '>+1<CR>gv=gv", "Move visual selection down" },
      ["K"] = { ":m '<-2<CR>gv=gv", "Move visual selection up" },
    },
  },
}
