require("fibsus.remap")
require("fibsus.packer")
require("fibsus.set")
vim.api.nvim_command('command! -range=% MBTISort lua require"mbtisort".mbtisort(<line1>, <line2>)')
