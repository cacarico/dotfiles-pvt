-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    -- local function set_keymap(mode, lhs, rhs, desc, opts)
    --     local options = {buffer = event.buf}
    --         vim.keymap.set('n')
    --     end
    -- end

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end
})

  -- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver', 'gopls', 'bashls' , 'lua_ls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

require'lspconfig'.terraform_lsp.setup{
    filetypes = {"terraform", "tf"}
}

require'lspconfig'.elixirls.setup{
    cmd = {"/home/cacarico/.asdf/shims/elixir-ls"},
    filetypes = {"elixir", "eelixir", "heex", "surface"},
    root_dir = require'lspconfig'.util.root_pattern("mix.exs", ".git"),
    settings = {
        elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
            enableTestLenses = false
        }
    }
}

require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  -- snippet = {
  --   expand = function(args)
  --     luasnip.lsp_expand(args.body)
  --   end,
  -- },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-o>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
  },
}
