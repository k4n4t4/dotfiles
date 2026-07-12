return function()
    local name = require("utils.info").buf.name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    if not name or name == "" then return nil end

    return name
end
