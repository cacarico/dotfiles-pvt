vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", '<leader>p', '"+p')

-- Next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Leave insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- Disables Q
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<C-s>", ":w <CR>")
-- Sed commands
--
-- Replace all occurrences of the current word under the cursor with the same word
vim.keymap.set("n", "<leader>sg", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]])

-- Moves using Alt hjkl
vim.keymap.set("n", '<A-h>', '<C-w>h', {noremap = true})
vim.keymap.set("n", '<A-j>', '<C-w>j', {noremap = true})
vim.keymap.set("n", '<A-k>', '<C-w>k', {noremap = true})
vim.keymap.set("n", '<A-l>', '<C-w>l', {noremap = true})

vim.keymap.set("n", '<C-q>', ':bd<CR>', { noremap = true })

-- Resize split
vim.keymap.set("n", '<A-S-l>', ':vertical resize -5<CR>')
vim.keymap.set("n", '<A-S-k>', ':resize +5<CR>')
vim.keymap.set("n", '<A-S-j>', ':resize -5<CR>')
vim.keymap.set("n", '<A-S-h>', ':vertical resize +5<CR>')

-- Move split
vim.keymap.set("n", '<A-C-h>', '<C-w>H', {silent = true})
vim.keymap.set("n", '<A-C-j>', '<C-w>J', {silent = true})
vim.keymap.set("n", '<A-C-k>', '<C-w>K', {silent = true})
vim.keymap.set("n", '<A-C-l>', '<C-w>L', {silent = true})

-- Windows
vim.keymap.set("n", "\\\\", ":vsplit<CR>")

-- Starts lazyvim in the current project
vim.keymap.set("n", "<C-g>", "<cmd>silent !fish -c 'floating_git'<CR>")
