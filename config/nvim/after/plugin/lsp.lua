require("nvim-web-devicons").setup()

-- --------------------------------------
-- FUNCTIONS
-- --------------------------------------

local function rename_file(old_name, new_name)
	-- Rename file
	vim.cmd(string.format("silent !mv %s %s", old_name, new_name))

	-- Open the new file
	vim.cmd(string.format("edit %s", new_name))

	-- Create rename request parameters
	local params = vim.lsp.util.make_position_params()

	-- Add new name to parameters
	params.newName = new_name
	--
	-- -- Calls LSP rename to update references
	-- local params = {
	-- 	newName = new_name,
	-- 	textDocument = vim.lsp.util.make_text_document_params(),
	-- }

	vim.lsp.buf_request(0, "textDocument/rename", params, function(err, _, result)
		if err then
			vim.notify("Error renaming file: " .. err.message)
		elseif result then
			vim.lsp.util.apply_workspace_edit(result, "utf-8")
			vim.notify("File and references renamed!")
		end
	end)
end

-- NOTE: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

-- Adds mapping when attached to LSP
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local function map(mode, lhs, rhs, desc)
			local opts = { buffer = event.buf, desc = desc }
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Displays information about the symbol")
		map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition")
		map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration")
		map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
		map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type of definition")
		map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Go to reference")
		map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Display signature information")
		map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Renames symbol")
		map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
		vim.api.nvim_set_keymap("n", "<leader>rf", "", {
			desc = "Renames File and References",
			noremap = true,
			callback = function()
				local old_name = vim.fn.expand("%") -- Get the current file name
				local new_name = vim.fn.input("New file name: ", old_name) -- Ask user for the new name
				if new_name and new_name ~= old_name then
					rename_file(old_name, new_name)
				else
					vim.notify("Rename canceled or invalid new name.")
				end
			end,
		})
	end,
})

-- --------------------------------------
-- LSP
-- --------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
	bashls = {},
	clangd = {},
	docker_compose_language_service = {},
	dockerls = {
		settings = {
			docker = {
				languageserver = {
					formatter = {
						--TODO Check if needed
						ignoreMultilineInstructions = true,
					},
				},
			},
		},
	},
	elixirls = {
		cmd = { "/home/cacarico/.asdf/shims/elixir-ls" },
		filetypes = { "elixir", "eelixir", "heex", "surface" },
		root_dir = require("lspconfig").util.root_pattern("mix.exs", ".git"),
		settings = {
			elixirLS = {
				dialyzerEnabled = false,
				fetchDeps = false,
				enableTestLenses = false,
			},
		},
	},
	emmet_language_server = {},
	gopls = {},
	helm_ls = {
		settings = {
			["helm-ls"] = {
				yamlls = {
					path = "yaml-language-server",
				},
			},
		},
	},
	lua_ls = {
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- This is needed to fix "undefined field fs_stat"
						"${3rd}/luv/library",
					},
				},
			})
		end,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" }, -- Tell the LSP that `vim` is a global variable
				},
			},
		},
	},
	markdown_oxide = {},
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = false,
				},
			},
		},
	},
	rust_analyzer = {},
	sqls = {},
	terraformls = {
		filetypes = { "terraform", "terraform-vars", "tf" },
		root_dir = require("lspconfig").util.root_pattern(".terraform", ".git"),
	},
	tsserver = {},
	yamlls = {},
}

require("mason").setup({
	ui = {
		border = "rounded",
	},
})

-- Gets the keys from servers and appends other tools to be installed by Mason
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})

-- Installs Language Servers and extensions using Mason
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- Setup Language Servers
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

-- --------------------------------------
-- SNIPPETS
-- --------------------------------------
local luasnip = require("luasnip")

vim.keymap.set({ "i" }, "<C-K>", function()
	luasnip.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-N>", function()
	luasnip.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-P>", function()
	luasnip.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, { silent = true })

-- --------------------------------------
-- COMPLETION
-- --------------------------------------
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(), -- Adds border to the completion popup
		documentation = cmp.config.window.bordered(), -- Adds border to the documentation popup
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-o>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vim-dadbod-completion" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
})
