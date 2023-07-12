function ColorMyPencils(color)
    color = color or "tokyonight-moon"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.cmd('highlight LineNr guifg=#color1')
    vim.cmd('highlight CursorLineNr guifg=#color2')
end

ColorMyPencils()
