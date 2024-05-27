local home = os.getenv("HOME")

vim.g.startify_custom_header = vim.fn['startify#pad'](vim.fn['readfile'](home .. '/.config/nvim/extra/startify.txt'))
vim.g.startify_session_autoload = 1

local function gitModified()
    local files = vim.fn.systemlist('git ls-files -m 2>/dev/null')
    return vim.tbl_map(function(file) return { line = file, path = file } end, files)
end

local function gitUntracked()
    local files = vim.fn.systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return vim.tbl_map(function(file) return { line = file, path = file } end, files)
end

vim.g.startify_lists = {
    { type = 'dir',        header = { '   Project' } },
    { type = gitModified,  header = { '   Modified' } },
    { type = gitUntracked, header = { '   Untracked' } },
}
