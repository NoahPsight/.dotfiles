local plugins = {
    'folke/tokyonight.nvim',
    'rose-pine/neovim',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
    },
    'nvim-lua/plenary.nvim',
    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = {},
            }
        end
    },
    'nvim-treesitter/nvim-treesitter',
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-context",
    'theprimeagen/harpoon',
    "theprimeagen/refactoring.nvim",
    'theprimeagen/vim-be-good',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'github/copilot.vim',
    'wakatime/vim-wakatime',
    'christoomey/vim-tmux-navigator',
    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
    },
    -- LSP Support
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    -- Snippets
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
}

local opts = {}


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins, opts)
