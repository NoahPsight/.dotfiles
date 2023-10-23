return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "python-lsp-server",
        "rust-analyzer",
      },
    },
  },
}
