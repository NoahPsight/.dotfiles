
local plugins = {
    -- Themes
    'folke/tokyonight.nvim',
    'rose-pine/neovim',
    -- Functionality
    'nvim-telescope/telescope.nvim',
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
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- LSP Support
    'hrsh7th/cmp-nvim-lsp',
    'neovim/nvim-lspconfig',
    -- Autocompletion
    'L3MON4D3/LuaSnip',
    'hrsh7th/nvim-cmp',
    -- Icons
    'kyazdani42/nvim-web-devicons',
    'ryanoasis/vim-devicons',
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
