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
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          local null_ls = require "null-ls"
          local formatting = null_ls.builtins.formatting
          local diagnostics = null_ls.builtins.diagnostics
          local sources = {
            formatting.black.with {
              extra_args = { "--line-length", "79" },
            },
            formatting.rustfmt,
            formatting.clang_format,
            formatting.shfmt,
            formatting.stylua,
            formatting.phpcsfixer,
            formatting.prettier,
            diagnostics.shellcheck,
            diagnostics.eslint,
            diagnostics.flake8,
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
            "rust-analyzer",
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
          flags = { debounce_text_changes = 150 },
        })
        lspconfig[lsp].setup(opt)
      end
      lsp_init("pylsp", {})
      lsp_init("lua_ls", {})
      lsp_init("rust_analyzer", {})
      lsp_init("clangd", {
        filetypes = { "c", "cpp", "objc", "objcpp", "arduino" },
      })
      lsp_init("omnisharp", {})
      lsp_init("jdtls", {})
      lsp_init("tsserver", {})
      lsp_init("cssls", {})
      lsp_init("html", {})
      lsp_init("phpactor", {})
    end,
  },
}
