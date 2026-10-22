local M = {}

local function collect(ns)
    local out = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local i = vim.fn.getwininfo(win)[1]
        for _, m in ipairs(vim.api.nvim_buf_get_extmarks(buf, ns, { i.topline - 1, 0 }, { i.botline - 1, -1 }, {})) do
            local p = vim.fn.screenpos(win, m[2] + 1, m[3] + 1)
            -- row == 0 means not visible
            if p.row > 0 then out[#out + 1] = p end
        end
    end
    return out
end

function M.attach(ns, text)
    local shown
    local function update()
        local ps, s = collect(ns), {}
        local key = vim.inspect(ps)
        -- repaint only when the set of positions changed, so Neovim erases stale output
        if key ~= shown then
            shown = key
            vim.cmd.redraw({ bang = true })
        end
        for _, p in ipairs(ps) do
            s[#s + 1] = ('\27[%d;%dH%s'):format(p.row, p.col, text)
        end
        if #s > 0 then
            vim.api.nvim_ui_send('\0277' .. table.concat(s) .. '\0278')
        end
    end
    -- resend after every redraw, since Neovim may overwrite the cells
    vim.api.nvim_set_decoration_provider(ns, {
        on_start = function()
            vim.schedule(update)
        end,
    })
    return function()
        vim.api.nvim_set_decoration_provider(ns, {})
        vim.cmd.redraw({ bang = true })
    end
end

return M
