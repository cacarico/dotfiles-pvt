local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- mappings
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set({ "n", "v", "i" }, "h1", function() ui.nav_file(1) end)
vim.keymap.set({ "n", "v", "i" }, "h2", function() ui.nav_file(2) end)
vim.keymap.set({ "n", "v", "i" }, "h3", function() ui.nav_file(3) end)
vim.keymap.set({ "n", "v", "i" }, "h4", function() ui.nav_file(4) end)

vim.keymap.set("n", "<leader>hj", ui.nav_prev)
vim.keymap.set("n", "<leader>hl", ui.nav_next)
