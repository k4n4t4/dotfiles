local M = {}

function M.is_visual()
    local mode = vim.fn.mode()
    return mode == "v" or mode == "V" or mode == "\22"
end

function M.get_visual()
    local mode = vim.fn.mode()
    local start_pos = vim.fn.getpos "v"
    local end_pos = vim.fn.getpos "."
    local selection_lines = vim.fn.getregion(start_pos, end_pos, {
        type = mode,
    })

    if not selection_lines or #selection_lines == 0 then
        return
    end

    return {
        mode = mode,
        start_line = start_pos[2],
        start_col = start_pos[3],
        end_line = end_pos[2],
        end_col = end_pos[3],
    }
end

return M
