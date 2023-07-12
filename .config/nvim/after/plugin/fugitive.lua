vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gl", "<cmd>Git log<cr>")
vim.keymap.set("n", "<leader>gL", "<cmd>GlLog<cr>")

vim.keymap.set('n', '<leader>gf', ':echo "Fetching..." | Git fetch | echo "Fetched"<CR>')
vim.keymap.set('n', '<leader>gp', ':echo "Pulling..." | Git pull | echo "Pulled"<CR>')
vim.keymap.set('n', '<leader>gP', ':echo "Pushing..." | Git push | echo "Pushed"<CR>')
vim.keymap.set("n", "<leader>gB", "<cmd>Git blame<cr>")
