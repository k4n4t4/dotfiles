return function()
    local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))

    local name = path ~= "" and vim.fn.fnamemodify(path, ":t") or path
    if not name or name == "" then return nil end

    return name
end
