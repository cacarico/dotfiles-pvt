require('obsidian').setup({
  workspaces = {
      {
          name = "personal",
          path = "~/Documents/cacarico/"
      },
  },
  completion = {
    nvim_cmp = true, -- If you're using nvim-cmp for completion
  },
    templates = {
      folder = "~/Documents/cacarico/42 Templates/",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
  },
})

vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Search note on Obsidian" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>oN", "<cmd>ObsidianNew<CR>", { desc = "Insert Obsidian Template" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "Insert Obsidian from Template" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Rename Obsidian Note" })
