local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local trouble = require("trouble.providers.telescope")

require("telescope").load_extension('harpoon')
require('telescope').setup {
    defaults = {
        sorting_strategy = "descending",
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
                ["<C-o>"] = actions.select_default,
                ["<C-t>"] = trouble.open_with_trouble,
            },
            n = {
                ["<C-t>"] = trouble.open_with_trouble
            },
        }
    }
}

-- mappings
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fd', builtin.current_buffer_fuzzy_find, {})
