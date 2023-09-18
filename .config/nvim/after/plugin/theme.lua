function ColorMyPencils(color)
    --color = color or "tokyonight-moon"
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#3e8fb0', bold = false })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff', bold = true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#ea9a97', bold = false })
end

ColorMyPencils()
