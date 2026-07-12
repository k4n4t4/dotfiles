return function()
    local search = require("utils.info").buf.search_count(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    if not search then return nil end

    return search.current .. "/" .. search.total
end
