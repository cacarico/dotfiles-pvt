require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier" },
		yaml = { "yamlfix" },
	},
	stop_after_first = {
		javascript = true,
	},
})
