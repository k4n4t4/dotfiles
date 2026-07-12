return function()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    return require("utils.info").buf.encoding(bufnr)
end

