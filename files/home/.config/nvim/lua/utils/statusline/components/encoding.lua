return function()
    local enc = vim.api.nvim_get_option_value("fileencoding", {
        buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    })
    return enc ~= "" and enc or vim.o.encoding
end
