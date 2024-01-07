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
    "preservim/tagbar",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "python-lsp-server",
            "lua-language-server",
            "clangd",
            "omnisharp",
            "jdtls",
            "typescript-language-server",
            "css-lsp",
            "html-lsp",
            "phpactor",
            "prettier",
            "stylua",
            "black",
            "php-cs-fixer",
            "debugpy",
          },
          automatic_installation = true,
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
          flags = {
            debounce_text_changes = 150,
          },
        })
        lspconfig[lsp].setup(opt)
      end
      lsp_init("pylsp", {})
      lsp_init("lua_ls", {})
      lsp_init("rust_analyzer", {})
      lsp_init("clangd", {})
      lsp_init("omnisharp", {})
      lsp_init("jdtls", {})
      lsp_init("tsserver", {})
      lsp_init("cssls", {})
      lsp_init("html", {})
      lsp_init("phpactor", {})
    end,
  },
}
