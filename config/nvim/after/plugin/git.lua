-- Sets gitsisgn changes color to purple
vim.cmd("highlight GitSignsChange guifg=#703dad")

require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
		map("v", "<leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage selected hunk" })
		map("v", "<leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset selected hunk" })
		map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>gbb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame line (full)" })
		map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
		map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
		map("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end, { desc = "Diff this (against previous commit)" })
		map("n", "<leader>gdd", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

		-- mappings
		vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "Opens Git Fugitive" })
		vim.keymap.set("n", "<leader>gB", "<cmd>GBrowse<CR>", { desc = "Opens buffer on browser" })
	end,
})
