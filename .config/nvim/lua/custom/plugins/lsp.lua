local cmp = require "cmp"

local function table_combine(t1, t2)
  local new_table = {}
  for k, v in pairs(t1) do
    new_table[k] = v
  end
  for k, v in pairs(t2) do
    new_table[k] = v
  end
  return new_table
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      local configs = require("plugins.configs.lspconfig")
      local on_attach = configs.on_attach
      local capabilities = configs.capabilities
      local lspconfig = require "lspconfig"


      local function lsp_init(lsp, opt)
        opt = opt or {}
        opt = table_combine(opt, {
          on_attach = attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150,
          },
        })
        lspconfig[lsp].setup(opt)
      end

      lsp_init("html")
      lsp_init("cssls")
      lsp_init("bashls")
      lsp_init("clangd")
      lsp_init("gopls")
      lsp_init("rls")
      lsp_init("tsserver")
      lsp_init(
        "pylsp", { filetypes = {"python"} }
      )
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      table.insert(M.sources, {name = "crates"})
      return M
    end,
  },
}
