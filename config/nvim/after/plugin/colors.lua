---------------------
-- Nvim colorscheme
---------------------

-- -- Ensure full transparency by setting the background to NONE
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

-- -- Neo-tree settings for transparency
-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })

-- -- Bufferline settings for transparency
-- vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineTab", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineTabSelected", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineTabClose", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineCloseButton", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineCloseButtonVisible", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", { bg = "NONE" })

require("catppuccin").setup({
	flavour = "frappe", -- latte, frappe, macchiato, mocha
	transparent_background = true,
})

function ColorMyPencils(color)
	-- color = color or "rose-pine"
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
end

ColorMyPencils()
