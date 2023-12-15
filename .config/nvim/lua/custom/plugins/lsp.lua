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
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          local null_ls = require "null-ls"
          local formatting = null_ls.builtins.formatting
          local lint = null_ls.builtins.diagnostics
          local sources = {
            formatting.prettier,
            formatting.stylua,
            formatting.black,
            formatting.rustfmt,
            lint.shellcheck,
          }
          null_ls.setup {
            debug = true,
            sources = sources,
          }
        end,
      },
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "python-lsp-server",
            "lua-language-server",
            "prettier",
            "stylua",
            "black",
          },
        },
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local configs = require "plugins.configs.lspconfig"
      local on_attach = configs.on_attach
      local capabilities = configs.capabilities
      local function lsp_init(lsp, opt)
        opt = opt or {}
        opt = table_combine(opt, {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 },
        })
        lspconfig[lsp].setup(opt)
      end
      lsp_init("pylsp", {})
      lsp_init("lua_ls", {})
      lsp_init("rust_analyzer", {})
    end,
  },
}
