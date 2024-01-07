return {
  {
    "NvChad/nvterm",
    enabled = false,
    --TODO I found a way to disable this plugin, couln't find out
    --how to not have it install. sorry for small bloat
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      columns = {
        "icon",
      },
      default_file_explorer = true,
      restore_win_options = true,
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-p>"] = "actions.preview",
        ["<C-n>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".."
        end,
      },
    },
    init = function()
      local map = require "custom.mappings"
      map.oil = {
        n = {
          ["<C-n>"] = {
            "<cmd> Oil <CR>",
            "Open oil",
          },
        },
      }
      map.disabled.n["<C-n>"] = ""
      map.disabled.n["<leader>e"] = ""
    end,
  },
}
