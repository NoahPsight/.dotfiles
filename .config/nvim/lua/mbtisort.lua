local M = {}

M.mbtisort = function(start, finish)
    local order = {
        ESTJ = 1,
        ESTP = 2,
        ENTJ = 3,
        ENFJ = 4,
        ESFJ = 5,
        ESFP = 6,
        ENTP = 7,
        ENFP = 8,
        ISTJ = 9,
        ISTP = 10,
        INTJ = 11,
        INFJ = 12,
        ISFJ = 13,
        ISFP = 14,
        INTP = 15,
        INFP = 16
    }

    start = start - 1 -- Lua is 1-indexed, but Neovim API expects 0-indexed for lines.
    local lines = vim.api.nvim_buf_get_lines(0, start, finish, false)

    table.sort(lines, function(a, b)
        local aType = a:match("(%u%u%u%u)") or ""
        local bType = b:match("(%u%u%u%u)") or ""
        return (order[aType] or math.huge) < (order[bType] or math.huge)
    end)

    vim.api.nvim_buf_set_lines(0, start, finish, false, lines)
end

return M
