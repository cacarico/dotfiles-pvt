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
    --
    -- Git integration to show git signs on buffer
    "lewis6991/gitsigns.nvim",
    -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
    "folke/trouble.nvim",
    -- Automatically comments with gc
    "tpope/vim-commentary",
    --TODO Improve fugitive or remove | Plugin to manage git using the file
    "tpope/vim-fugitive",
    --TODO Really needed?
    "neovim/nvim-lspconfig",
    --TODO Or tune or find alternative | Show color on buffer
    "norcalli/nvim-colorizer.lua",
    -- "dag/vim-fish",
    "preservim/vim-indent-guides",
    -- Automatically insert pairs
    "windwp/nvim-autopairs",
    -- Remembers last cursor location
    "farmergreg/vim-lastplace",
    --TODO Probably remove
    -- "mg979/vim-visual-multi",
    -- Trims white spaces and new lines
    "cappyzawa/trim.nvim",
    -- Auto Format code on save
    "stevearc/conform.nvim",
    -- Auto create the other part of surround
    { "kylechui/nvim-surround",          event = "VeryLazy", },
    --TODO Check if really needed
    { "folke/neoconf.nvim",              cmd = "Neoconf" },
    -- highlighting
    { "nvim-treesitter/nvim-treesitter", cmd = "TSUpdate" },
    --TODO Maybe remove? Can see how treesitter is generating the highlighting
    -- "nvim-treesitter/playground",
    -- Shows where inside the context I am
    "nvim-treesitter/nvim-treesitter-context",
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
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
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
    -- { 'towolf/vim-helm',       ft = 'helm' },

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
    "stevearc/oil.nvim",
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
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
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
    {
    "L3MON4D3/LuaSnip",
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
    },
    "onsails/lspkind.nvim"
})
