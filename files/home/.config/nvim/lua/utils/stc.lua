local M = {}

M.global_name = "StatusColumn"
M.group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })
M.callbacks = {}

function M.make_str(tbls, stat)
    stat = stat or {}

    if not stat.is_child then M.callbacks = {} end

    stat.hl = stat.hl or ""
    stat.click = stat.click or ""

    local str = ""
    for _, tbl in ipairs(tbls) do
        if type(tbl) == "string" then
            str = str .. tbl
        elseif type(tbl) == "table" then
            local hl = tbl.hl or stat.hl
            local click_name = stat.click

            if tbl.click and tbl.click.name and tbl.click.callback then
                click_name = tbl.click.name
                M.callbacks[click_name] = tbl.click.callback
            end

            local node_content = tbl.content
            local content = ""
            if type(node_content) == "string" then
                content = node_content
            elseif type(node_content) == "table" then
                content = M.make_str(node_content, { hl = hl, click = click_name, is_child = true })
            end

            local click_str = ""
            local restore_click = ""
            if tbl.click and tbl.click.name then
                click_str = "%@v:lua." .. M.global_name .. ".callbacks." .. tbl.click.name .. "@"
                restore_click = (stat.click == "") and (
                    "%X"
                ) or (
                    "%@v:lua." .. M.global_name .. ".callbacks." .. stat.click .. "@"
                )
            end

            if tbl.hl then
                local restore_hl = (stat.hl == "") and (
                    "%*"
                ) or (
                    "%#" .. stat.hl .. "#"
                )
                str = str .. "%#" .. tbl.hl .. "#" .. click_str .. content .. restore_click .. restore_hl
            else
                str = str .. click_str .. content .. restore_click
            end
        end
    end
    return str
end

function M.setup(opts)
    vim.opt.signcolumn = "no"
    vim.opt.foldcolumn = '0'

    opts = opts or {}

    M.global_name = opts.global_name or M.global_name
    _G[M.global_name] = M

    opts.statuscolumn = opts.statuscolumn or function() return "" end
    M.statuscolumn = function()
        local current_winid = vim.api.nvim_get_current_win()
        local statuscolumn_winid = vim.g.statusline_winid
        local statuscolumn_bufnr = vim.api.nvim_win_get_buf(statuscolumn_winid)
        local active = current_winid == statuscolumn_winid

        return opts.statuscolumn {
            current_winid = current_winid,
            statuscolumn_winid = statuscolumn_winid,
            bufnr = statuscolumn_bufnr,
            active = active,
        }
    end

    vim.opt.statuscolumn = "%!v:lua."..M.global_name..".statuscolumn()"
end

return M
