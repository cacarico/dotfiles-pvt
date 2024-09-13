require("conform").setup({
	-- format_on_save = {
	-- 	-- These options will be passed to conform.format()
	-- 	timeout_ms = 500,
	-- 	lsp_format = "fallback",
	-- },
  format_after_save = {
    lsp_format = "fallback",
  },
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier" },
		yaml = { "yamllint", "yamlfix" },
		fish = { "fish_ident" },
	},
	stop_after_first = {
		javascript = true,
	},
	formatters = {
		yamlfix = {},
	},
})
