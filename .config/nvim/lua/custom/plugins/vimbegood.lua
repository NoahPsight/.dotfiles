return {
  {
    "ThePrimeagen/vim-be-good",
    lazy = false,
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
    config = function()
      require("hardtime").setup()
    end,
    lazy = false,
  },
}
