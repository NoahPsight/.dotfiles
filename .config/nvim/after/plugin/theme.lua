function ColorMyPencils(color)
    color = color or "tokyonight-moon"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51b3ec', bold = false })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff', bold = true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#eb81e5', bold = false })
end

ColorMyPencils()
