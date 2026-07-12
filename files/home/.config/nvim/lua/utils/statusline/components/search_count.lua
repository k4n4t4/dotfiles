local function search_count(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if b ~= vim.api.nvim_get_current_buf() or vim.v.hlsearch == 0 then
        return nil
    end

    local ok, search = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 999, timeout = 100 })
    if not ok or next(search) == nil or search.total == 0 then
        return nil
    end

    return search
end

return function()
    local search = search_count(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    if not search then return nil end

    return search.current .. "/" .. search.total
end
