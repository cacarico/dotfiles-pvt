require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "javascript", "typescript", "c", "lua", "rust", "go", "jsonnet", "bash", "fish", "python", "terraform", "markdown", "markdown_inline", "vim", "regex" },

    sync_install = true,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}

-- Enable Treesitter folding for Go files
vim.cmd("autocmd FileType go setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()")

-- Enable syntax highlighting for Go using the go.nvim plugin
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_operators = 1

vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_generate_tags = 1
