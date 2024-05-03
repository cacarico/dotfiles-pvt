local fineline = require('fine-cmdline')

fineline.setup({

    vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true}),

    -- after_mount = function(input)
    --   -- make escape go to normal mode
    --   vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', {buffer = input.bufnr})
    -- end


})
