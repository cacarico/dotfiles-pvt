require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/cacarico",
		},
	},
	completion = {
		nvim_cmp = true, -- If you're using nvim-cmp for completion
	},
	templates = {
		folder = "~/cacarico/42 Templates/",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
	},
})

vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Search note on Obsidian" })
