return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      server = {
        on_attach = require("plugins.configs.lspconfig").on_attach,
        capabilities = require("plugins.configs.lspconfig").capabilities,
      },
    },
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      local crates = require "crates"
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()
      require("core.utils").load_mappings "crates"
    end,
    init = function()
      local map = require "custom.mappings"
      map.crates = {
        plugin = true,
        n = {
          ["<leader>rcu"] = {
            function()
              require("crates").upgrade_all_crates()
            end,
            "update crates",
          },
        },
      }
    end,
  },
}
