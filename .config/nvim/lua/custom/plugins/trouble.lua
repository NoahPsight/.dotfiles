return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    local map = require "custom.mappings"
    local t = require "trouble"

    map.trouble = {
      n = {
        ["<leader>xx"] = { t.toggle, "Toggle Trouble" },
        ["<leader>xw"] = {
          function()
            t.toggle "workspace_diagnostics"
          end,
          "Toggle Workspace Diagnostics",
        },
        ["<leader>xd"] = {
          function()
            t.toggle "document_diagnostics"
          end,
          "Toggle Document Diagnostics",
        },
        ["<leader>xq"] = {
          function()
            t.toggle "quickfix"
          end,
          "Toggle Quickfix",
        },
        ["<leader>xl"] = {
          function()
            t.toggle "loclist"
          end,
          "Toggle Location List",
        },
        ["gR"] = {
          function()
            t.toggle "lsp_references"
          end,
          "LSP References",
        },
      },
    }
  end,
}
