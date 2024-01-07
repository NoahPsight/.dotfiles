local map = require "custom.mappings"
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("core.utils").load_mappings "dap"
    end,
    init = function()
      map.dap = {
        plugin = true,
        n = {
          ["<leader>db"] = {
            "<cmd> DapToggleBreakpoint <CR>",
            "Toggle Breakpoint",
          },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings "dap_python"
    end,
    init = function()
      map.dap_python = {
        plugin = true,
        n = {
          ["<leader>dpr"] = {
            function()
              require("dap-python").test_method()
            end,
            "Run python debug",
          },
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
