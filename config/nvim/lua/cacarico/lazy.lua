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

require("lazy").setup({

    -- Code
    "folke/neodev.nvim",
    "lewis6991/gitsigns.nvim",
    "folke/trouble.nvim",
    "nvim-treesitter/playground",
    "tpope/vim-commentary",
    "tpope/vim-fugitive",
    "neovim/nvim-lspconfig",
    "norcalli/nvim-colorizer.lua",
    "dag/vim-fish",
    "nvim-treesitter/nvim-treesitter-context",
    "preservim/vim-indent-guides",
    "windwp/nvim-autopairs",
    "farmergreg/vim-lastplace",
    "junegunn/goyo.vim",
    "mg979/vim-visual-multi",
    "cappyzawa/trim.nvim",
    "stevearc/conform.nvim",
    { "kylechui/nvim-surround",          event = "VeryLazy", },
    { "folke/neoconf.nvim",              cmd = "Neoconf" },
    { "nvim-treesitter/nvim-treesitter", cmd = "TSUpdate" },
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" },
            -- Nvim cmp
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
        }
    },
    -- Obsidian
    {
        "epwalsh/obsidian.nvim",
        lazy = true,
        ft = "markdown"
    },
    -- Debugger
    {
        "mfussenegger/nvim-dap",
        dependencies = "nvim-neotest/nvim-nio"
    },
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    { 'towolf/vim-helm',       ft = 'helm' },

    -- UI
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
        -- add any options here
      },
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
        }
    },
    "epwalsh/pomo.nvim",
    -- Navigation
    "mhinz/vim-startify",
    "nathom/tmux.nvim",
    "ThePrimeagen/harpoon",
    "ThePrimeagen/refactoring.nvim",
    'akinsho/bufferline.nvim',
    "easymotion/vim-easymotion",
    "mbbill/undotree",
    "folke/which-key.nvim",
    "stevearc/dressing.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons"
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = "nvim-lua/plenary.nvim"
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "kristijanhusak/vim-dadbod-completion",
            "tpope/vim-dadbod",
        }
    },
    -- Preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    { "ellisonleao/glow.nvim", config = true,       cmd = "Glow" },

    -- Colors
    { "rose-pine/neovim",      name = "rose-pine" },
    { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
    -- "Mofiqul/dracula.nvim",
    "AlessandroYorba/Alduin",

    -- Databases
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
            "kristijanhusak/vim-dadbod-completion"
        },
    },


})
