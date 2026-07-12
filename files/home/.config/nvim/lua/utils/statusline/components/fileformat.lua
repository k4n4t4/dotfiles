return function(opts)
    local default_formats = {
        ["unix"] = { icon = " ", label = "LF" },
        ["dos"]  = { icon = " ", label = "CRLF" },
        ["mac"]  = { icon = " ", label = "CR" },
    }
    local formats = opts and vim.tbl_deep_extend("force", default_formats, opts) or default_formats

    local fmt = vim.api.nvim_get_option_value("fileformat", { buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid) })
    if not fmt or fmt == "" then return nil end

    return formats[fmt] or { icon = "", label = fmt }
end

