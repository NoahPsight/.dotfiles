require('telescope').setup {}
require("projections").setup({})
require('telescope').load_extension('projections')
local builtin = require('telescope.builtin')
local Session = require("projections.session")
local switcher = require("projections.switcher")
local Workspace = require("projections.workspace")

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    callback = function()
        Session.store(vim.loop.cwd())
    end,
})
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
    end,
})

vim.keymap.set("n", "<leader>,,", function()
    Session.store(vim.loop.cwd())
    vim.cmd("Telescope projections")
end)
vim.keymap.set("n", "<leader>h", function()
    Session.store(vim.loop.cwd())
    vim.cmd("silent! bufdo bd")
    vim.cmd("cd ~")
    vim.cmd("Alpha")
end)
vim.keymap.set("n", "<leader><leader>", function()
    vim.lsp.buf.format()
    vim.cmd("w")
    Session.store(vim.loop.cwd())
    vim.cmd("echo 'Formatted and Saved'")
end)
vim.api.nvim_create_user_command("AddWorkspace", function()
    Workspace.add(vim.loop.cwd() .. "/../", {})
    Session.store(vim.loop.cwd())
end, {})
vim.keymap.set('n', '<leader>,f', builtin.find_files, {})
vim.keymap.set('n', '<leader>,b', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>,s', builtin.live_grep, {})

