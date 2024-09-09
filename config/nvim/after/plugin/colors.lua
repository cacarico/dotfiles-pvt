---------------------
-- Nvim colorscheme
---------------------

-- Imports catppuccin
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
