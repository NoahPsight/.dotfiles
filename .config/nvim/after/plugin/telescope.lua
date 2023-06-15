require('telescope').setup {}
local builtin = require('telescope.builtin')

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    callback = function()
        vim.cmd("SessionSave")
    end,
})
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd("SessionRestore")
        end
    end,
})

vim.keymap.set("n", "<leader><leader>", function()
    vim.lsp.buf.format()
    vim.cmd("w")
    vim.cmd("SessionSave")
    vim.cmd("echo 'Formatted and Saved'")
end)

vim.keymap.set('n', '<leader>,f', builtin.find_files, {})
vim.keymap.set('n', '<leader>,b', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>,s', builtin.live_grep, {})
