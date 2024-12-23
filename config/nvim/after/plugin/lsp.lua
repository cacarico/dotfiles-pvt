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
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Displays information about the symbol")
		map("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition")
		map("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration")
		map("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
		map("go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type of definition")
		map("gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Go to reference")
		map("gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Display signature information")
		map("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Renames symbol")
		map("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
		vim.api.nvim_set_keymap("n", "<leader>rf", "", {
			desc = "Renames File and References",
			noremap = true,
			callback = function()
				local old_name = vim.fn.expand("%") -- Get the current file name
				local new_name = vim.fn.input("New file name: ", old_name) -- Ask user for the new name
				if #new_name > 1 and new_name ~= old_name then
					rename_file(old_name, new_name)
				else
					vim.notify("Rename canceled or invalid new name.")
				end
			end,
		})

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[t]oggle inlay [h]ints")
		end
	end,
})

-- --------------------------------------
-- LSP
-- --------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").fish_lsp.setup({})

----
--vim.filetype.add({
--  extension = {
--    rockspec = 'rockspec',
--  },
--})

local servers = {
	bashls = {},
	clangd = {},
	docker_compose_language_service = {},
	dockerls = {
		settings = {
			docker = {
				languageserver = {
					formatter = {
						--TODO: Check if needed
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
	-- Language server for frontend
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
		on_init = function(lua_client)
			local path = lua_client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end

			lua_client.config.settings.Lua = vim.tbl_deep_extend("force", lua_client.config.settings.Lua, {
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
						"/home/cacarico/.luarocks/lib/luarocks/rocks-5.4",
					},
				},
			})
		end,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "hyprlua", },
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
	ts_ls = {},
	vimls = {},
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
	"luacheck",
	"stylelint",
	"htmlbeautifier",
	-- "markdownfmt",
	"cbfmt",
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
